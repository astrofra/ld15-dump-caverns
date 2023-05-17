//
	Include("scriptlib/nad.nut");

class Character
{
	body				= 0
	scene				= 0

	max_frame			= 15
	current_frame		= 0

	time_frame			= 0.0

	u					= 0.0
	v					= 0.0

	pos					= 0
	hit					= 0

	character_material	= 0

	walk_x_delta		= [	2,3,1,0,
							6,4,3,4,
							2,3,0,6,
							4,3,4 ]

	//-----------------------
	function	OnSetup(item)
	{
		print("Character::OnSetup()")

		body	= item
		scene	= ItemGetScene(body)
		pos		= Vector()

		local	item_geo = ItemGetGeometry(item);
		character_material = GeometryGetMaterial(item_geo, "character");

		pos = ItemGetWorldPosition(SceneFindItem(scene, "spawnpoint"))
		pos.z = ItemGetWorldPosition(item).z

		local	hit = BlockRaytrace(pos + Vector(0, Mtr(100), 0), Vector(0, -1, 0))
		if (hit.hit)
			pos.y = hit.p.y

		for (local n = 0; n < walk_x_delta.len(); n++)
			walk_x_delta[n] = walk_x_delta[n] * 0.15;
	}
	
	function	OnClick(parms)
	{
	}

	//---------------------------
	function	CycleFrame(_u,_v)
	{
		local	m = TransformationMatrix
			(
				Vector(_u, _v, 0.0),			// Position
				Vector(0.0, 0.0, 0),			// Rotation
				Vector(1.0, 1.0, 1.0),			// Scale
				Vector(0.0, 0.0, 0.0)			// Pivot
			);

		MaterialChannelSetUVMatrix(character_material, ChannelColor, m);
		MaterialChannelSetUVMatrix(character_material, ChannelOpacity, m);
		MaterialUpdate(character_material);
	}

	//-------------------------------------------
	function	BlockRaytrace(_ray_pos, _ray_dir)
	{
		return SceneCollisionRaytrace(scene, _ray_pos, _ray_dir, 1, CollisionTraceAll);
	}

	//------------------------
	function	AltitudeDelta()
	{
		//	Anticipate obstacles
		local	max_y_delta = 0.0;
		for (local n = 0; n < 5; n++)
		{
			local	ray_pos_ahead = pos + Vector(Mtr(n * 0.25 + 0.25), Mtr(3.0),0)

			local	hit_ahead = BlockRaytrace(ray_pos_ahead, Vector(0, -1, 0))
			if (hit_ahead.hit)
			{
				if (g_debug)
					RendererDrawCross(g_render, hit_ahead.p + Vector(0,0,0.25));
				if (ItemGetName(ShapeGetItem(hit_ahead.shape)) != "ground_block")
					if (Abs(hit_ahead.p.y - pos.y) > Abs(max_y_delta))
						max_y_delta = hit_ahead.p.y - pos.y
			}
		}

		return (max_y_delta);
	}

	//-------------------
	function	Walk()
	{	
		//print("Character::Walk()")
		time_frame += g_dt_frame * 10.0;

		current_frame = (time_frame.tointeger())%15;

		u = (current_frame%4).tofloat() * 0.25;
		v = (current_frame / 4).tofloat() * 0.25;

		CycleFrame(u,v);

		pos.x += g_dt_frame * walk_x_delta[current_frame];
	}

	//-------------------------
	function	FollowGround()
	{
		//print("Character::FollowGround()")

		local	hit_pos_y = []
		
		for (local n = 0; n < 12; n++)
		{
			local	ray_pos = pos + Vector(Lerp(n / 10.0, Cm(-30.0), Cm(30.0)),Mtr(3.0),0)
			hit = BlockRaytrace(ray_pos, Vector(0, -1, 0))
			if (hit.hit)
			{
				if (g_debug)
					RendererDrawCrossColored(g_render, hit.p + Vector(0,0,0.25), Vector(1,0.5,0))
				hit_pos_y.append(hit.p.y)
			}
		}

		hit_pos_y.sort()
		hit_pos_y = hit_pos_y[(hit_pos_y.len() / 2).tointeger()]

		if (hit.hit)
		{
			//	Simulate the weight of the character.
			local	item_hit = ShapeGetItem(hit.shape)

			ItemApplyForce(item_hit, Vector(pos.x, hit_pos_y, pos.z), Vector(0, -1, 0).MulReal(100.0))

			//	Adjust character's Y coordinate.
			if (hit_pos_y < pos.y)
				pos.y = Lerp(0.15, pos.y,hit_pos_y)
			else
			{
				if (hit_pos_y > pos.y)
				{
					if (Abs(hit_pos_y - pos.y) < Mtr(1.0))
						pos.y = Lerp(0.35, pos.y, hit_pos_y)
					else
						return (false)
				}
				else
				{
					if (Abs(hit_pos_y - pos.y) < Mtr(10.0))
						pos.y = Lerp(0.35, pos.y, hit_pos_y)
					else
						return (false)
				}
			}
		}

		return (true);
	}

	//--------------------------------------
	function	OnCollision(item, with_item)
	{
	}

	//-----------------------
	function	OnUpdate(item)
	{
		//print("Character::OnUpdate()")
		if (FollowGround())
		{
			local	_ad = AltitudeDelta()

			if ((_ad >= 0.0) && (_ad < Mtr(1.0)))	
				Walk()
			else
			{
				if ((_ad < 0.0) && (_ad > Mtr(-10.0)))	
					Walk()
			}
		}

		ItemSetPosition(item, pos)
	}
}