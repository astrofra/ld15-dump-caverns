//

class	RainEmitter
{

	scene		=	0
	pos			=	0
	player		=	0

	emit_freq	=	Sec(0.015)
	emit_clock	=	0.0
	org_part	=	0
	drop_part	=	0

	strength	=	1.0

	function	OnSetup(item)
	{
		scene = ItemGetScene(item)
		player = SceneFindItem(scene, "character")
		emit_clock = g_clock
		org_part = SceneFindItem(scene, "rain_particle")
		drop_part = SceneFindItem(scene, "rain_drop_particle")
	}

	function	OnUpdate(item)
	{
		if (strength <= 0.0)
			return

		local	player_pos	= ItemGetWorldPosition(player) 
		pos = player_pos + Vector(Mtr(10),Mtr(5),Mtr(1)).Scale(1.25)
		ItemSetPosition(item, pos)

		//	Drops on the ground
		if ((g_clock - emit_clock) > SecToTick(emit_freq))
		{
			if (Rand(0,100) < 25)
			{
				local	_pos = player_pos
				_pos += Vector(Rand(-8,10),5,0)
				local	hit = BlockRaytrace(_pos, Vector(0,-1,0))
				if (hit.hit)
				{
					local	new_part
					new_part = SceneDuplicateItem(scene, drop_part)

					ItemSetPosition(new_part, hit.p)
					ItemSetScale(new_part, Vector(0.35,0.35,0.35))
					ItemSetCommandList(new_part, "toscale 3,1,1,1+toalpha 0.5,0;")

					g_ace_deleter.RegisterItem(new_part)
				}
			}

			local	new_part
			new_part = SceneDuplicateItem(scene, org_part)

			local	_spread_pos = Vector(Rand(-0.2,0.2),Rand(-1,4),Rand(0.0,0.1))
			_spread_pos = _spread_pos.Scale(Rand(2,5))
			ItemSetPosition(new_part, pos + _spread_pos)
			ItemSetRotation(new_part, Vector(0, 0, DegreeToRadian(-55 + Rand(-5,5))))
			ItemSetScale(new_part, Vector(1,2,1).Scale(Rand(2,4)))
			//ItemSetAlpha(new_part, 0.5)

			ItemSetCommandList(new_part, "tooffset 4,0,-50,0+toalpha 4,0.15;")

			g_ace_deleter.RegisterItem(new_part)
		}

		emit_clock = g_clock
	}

	//-------------------------------------------
	function	BlockRaytrace(_ray_pos, _ray_dir)
	{
		return SceneCollisionRaytrace(scene, _ray_pos, _ray_dir, 1, CollisionTraceAll);
	}
}