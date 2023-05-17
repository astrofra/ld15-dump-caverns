// Fx global functions

Include("scriptlib/nad.nut")

function	FxCreateExplosion(scene, pos, _max_impact)
{
	for (local n = 0; n < _max_impact; n++)
	{
		local	fx_obj = SceneAddObject(scene, "explosion")
		local	fx_item = ObjectGetItem(fx_obj)
		ObjectSetGeometry(fx_obj, EngineLoadGeometry(g_engine, "data/meshes/smoke_ball.nmg"))

		ItemSetPosition(fx_item, pos + Vector(Rand(-20,20), Rand(-10,10), Rand(-20,20)))
		local	str = "nop " + (n * 0.1).tostring() + ";"
		str += "toalpha 0,1;toscale 0,0,0,0;"
		local size = Rand(2, 5)
		local str_size = size + "," + size + "," + size
		str += "toalpha 0,0;toalpha 0.125,1+tooffset 0.125,0,0.5,0+toscale 0.125," + str_size + ";nop 0.125;tooffset 2,0,5,0+toscale 2,0.5,0.5,0.5+toalpha 2.0,0.35;nop 0.5;"
		ItemSetCommandList(fx_item, str)
		ItemSetFlags(fx_item, ItemFlagBillboard, true)
		g_ace_deleter.RegisterItem(fx_item)
	}
}

function	FxCreateWaterImpact(scene, pos)
{
		local	fx_obj = SceneAddObject(scene, "water_impact")
		local	fx_item = ObjectGetItem(fx_obj)

		pos.y = Mtr(0.0)
		ItemSetPosition(fx_item, pos)
		ItemSetScale(fx_item, Vector(0,0,0))
		ItemSetRotation(fx_item, Vector(0,DegreeToRadian(Rand(0.0,90.0)),0))

		ObjectSetGeometry(fx_obj, EngineLoadGeometry(g_engine, "data/meshes/water_impact.nmg"))

		local	str = "toscale 0,0,0,0;"

		str += "toscale 0.1,0.5,0.5,0.5;"
		str += "toscale 0.1,0.75,1.0,0.75;"
		str += "toscale 0.25,0.75,2.0,0.75+tooffset 0.25,0,1,0;nop 0.125;"
		str += "toscale 0.25,0.5,1.0,0.5+tooffset 0.125,0,-0.5,0;"
		str += "toscale 0.15,0.15,0.15,0.15;"
		
		ItemSetCommandList(fx_item, str)

		g_ace_deleter.RegisterItem(fx_item)
}

function	FxCreateHitCount(scene, base_item, clockwise, damage)
{
	damage = Clamp(damage, 0, 4)
	local	fx_obj = SceneAddObject(scene, "damage")
	local	fx_item = ObjectGetItem(fx_obj)
	
	local	pos = ItemGetPosition(base_item),
			rot = ItemGetRotation(base_item)

	if (clockwise)
		rot.y += DegreeToRadian(180.0)

	local	_dist = Vector(0,0,0).Dist(pos)
	local	_min = Mtr(200.0),
			_max = Mtr(1400.0)
	local	_scale = RangeAdjust(Clamp(_dist, _min, _max),  _min, _max, 1.0, 3.0) 
	
	if (damage > 0) 
		ObjectSetGeometry(fx_obj, EngineLoadGeometry(g_engine, "data/meshes/damage_" + damage + ".nmg"))
	else
		ObjectSetGeometry(fx_obj, EngineLoadGeometry(g_engine, "data/meshes/damage_skull.nmg"))

	ItemSetPosition(fx_item, pos + Vector(0,Mtr(25),0))
	ItemSetScale(fx_item, Vector(_scale, _scale, _scale))
	ItemSetRotation(fx_item, rot)
	ItemSetCommandList(fx_item, "toalpha 0,0;nop 0.6;toalpha 0,1;tooffset 1.25,0,70,0+toalpha 1.25,0.25;toalpha 0,0;nop 1.0;")
	g_ace_deleter.RegisterItem(fx_item)
}