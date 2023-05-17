	Include("scriptlib/nad.nut");

g_block_counter		<-	0

class	PlayScene
{

	mouse_x			= 0.0
	mouse_y			= 0.0
	x				= 0.0
	y				= 0.0
	x_speed			= 0.0
	y_speed			= 0.0

	game_plane		= 0

	mouse_cursor	= 0

	current_cam		= 0
	mouse_3d		= Vector()
	world_mouse_3d	= Vector()
	ray_dir			= Vector(0,0,1)
	hit				= false

	check_timeout	= 0.0

	pick			= 0

	item_grabbed	= 0
	instance_grabbed
					= 0
	item_p			= 0

	intro_theme_sfx	= 0
	intro_theme_channel
					= 0

	//------------------------
	function	OnSetup(scene)
	{
		print("PlayScene::OnSetup()")
		g_block_counter = 0
		check_timeout = g_clock

		x			= 0.0
		y			= 0.0

		current_cam = SceneGetCurrentCamera(scene)

		mouse_cursor = SceneFindItem(scene, "mouse")

		//intro_theme_sfx = EngineLoadSound(g_engine, "data/sounds/erlkonig_trumpet_loop_16.wav")

		//MixerChannelSetGain(g_mixer, intro_theme_channel, 0.125)
		//MixerChannelSetPitch(g_mixer, intro_theme_channel, 0.35)
		
		game_plane = SceneFindItem(scene, "game_plane")

		ScenePhysicEnableDeactivation(scene, false)

		//MixerChannelStart(g_mixer, intro_theme_channel, intro_theme_sfx);	
	}

	//-------------------------------
	function	CheckSelection(scene)
	{
		if ((g_clock - check_timeout) < SecToTick(Sec(1.0)))
			return

		check_timeout = g_clock

		local	_item_list,
				_block_list,
				_item, i

		_item_list = SceneGetItemList(scene)
		_block_list = []

		foreach(i, _item in _item_list)
		{
			if (ItemGetName(_item).len() > 4)
			{
				if (ItemGetName(_item).slice(0,5) == "block")
				{
					if (ItemGetScriptInstance(_item).selected)
						_block_list.append(_item)
				}
			}
			
		}

		if (_block_list.len() < 3)
		{
			print("CheckSelection() : found less than 3 selected blocks.")
			return
		}

		print("CheckSelection() : found " + _block_list.len() + " selected blocks.")

		local	_block_name = [],
				_block_pos = []
		
		foreach(_item in _block_list)
		{
			_block_name.append(ItemGetName(_item))
			_block_pos.append(ItemGetWorldPosition(_item))
		}

		if (!((_block_name[0] == _block_name[1]) && (_block_name[0] == _block_name[2])))
		{
			print("CheckSelection() : Blocks found were of different type.")
			return
		}

		print("CheckSelection() : Blocks found are the same type.")

		local	_block_dist = [],
				_dist

		_block_dist.append(_block_pos[0].Dist(_block_pos[1]))
		_block_dist.append(_block_pos[0].Dist(_block_pos[2]))
		_block_dist.append(_block_pos[1].Dist(_block_pos[2]))

		_block_dist.sort()

		foreach(_dist in _block_dist)
			print("CheckSelection() : _dist = " + _dist + " meters.")

		if ((_block_dist[0] < Mtr(1.85)) && (_block_dist[1] < Mtr(1.85)))
		{
			print("CheckSelection() : Found a VALID row !!! Disabling it !")
			foreach(_item in _block_list)
			{
				ItemGetScriptInstance(_item).UnSelect()
				ItemActivate(_item, false)
			}
				
		}
	}

	//------------------------
	function	OnUpdate(scene)
	{
		MouseUpdate()

		//CheckSelection(scene)

		mouse_x = MousePoolFunction(DeviceAxisX) / 65536.0
		mouse_y = MousePoolFunction(DeviceAxisY) / 65536.0
		//mouse_x = mouse_x - 0.5
		//mouse_y = 0.5 - mouse_y

		mouse_3d = CameraScreenToWorldPlane(SceneGetCurrentCamera(scene), mouse_x, mouse_y, 9.0)
		//mouse_3d.z = -5.0
		mouse_3d.Print()
		ItemSetPosition(mouse_cursor, mouse_3d)

		world_mouse_3d = ItemGetWorldPosition(mouse_cursor)
		ray_dir = world_mouse_3d - ItemGetWorldPosition(CameraGetItem(current_cam))
		hit = SceneCollisionRaytrace(scene, world_mouse_3d, ray_dir, 1, CollisionTraceAll)

		local	mouse_button
		mouse_button = MousePoolFunction(DeviceButton0)

		if (item_grabbed == 0)
		{
			if (hit.hit)
			{
				ItemSetScale(mouse_cursor, Vector(1,1,1))
				if (mouse_button)
				{
					RendererDrawCross(g_render, hit.p)
					item_grabbed = hit.item //ShapeGetItem(hit.shape)
					hit.p.z = ItemGetWorldPosition(item_grabbed).z
					item_p = hit.p.ApplyMatrix(ItemGetInverseMatrix(item_grabbed))

					instance_grabbed = ItemGetScriptInstance(item_grabbed)
				}
			}
			else
				ItemSetScale(mouse_cursor, Vector(0.8,0.8,0.8))
		}
		else
		{
			//instance_grabbed.OnClick({_item_p = item_p, _world_mouse_3d = world_mouse_3d})

			if (!mouse_button)
			{
				item_grabbed = 0
			}
		}
	}

}