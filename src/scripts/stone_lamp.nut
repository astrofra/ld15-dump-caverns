//

class	StoneLamp
{

	scene		=	0
	pos			=	0
	scale		=	0
	emit_freq	=	Sec(0.25)
	emit_clock	=	0.0
	org_part	=	0

	function	OnSetup(item)
	{
		pos	= ItemGetWorldPosition(item)
		scale = ItemGetScale(item)
		emit_clock = g_clock
		scene = ItemGetScene(item)
		org_part = SceneFindItem(scene, "stone_lamp_particle")
	}

	function	OnUpdate(item)
	{

		ItemSetScale(item, scale.Scale(Rand(1,1.1)))

		if ((g_clock - emit_clock) > SecToTick(emit_freq))
		{
			local	_pos, _size, new_part
			_size = Rand(0.25,0.55)
			_pos = pos + Vector(Rand(-1,1), Rand(-1,1), 0).Normalize(_size)

			new_part = SceneDuplicateItem(scene, org_part)
			ItemSetPosition(new_part, _pos)
			ItemSetScale(new_part, Vector(_size,_size,_size))
			ItemSetAlpha(new_part, 0.5)
			ItemSetCommandList(new_part, "tooffset 1,0,3.5,0+toalpha 1,0.0;")

			g_ace_deleter.RegisterItem(new_part)

			emit_clock = g_clock
		}
	}

}