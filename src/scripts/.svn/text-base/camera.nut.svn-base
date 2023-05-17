// Camera
	Include("scriptlib/nad.nut");

class	CameraHandler
{

	pos 			= Vector();
	character		= 0;
	character_pos	= Vector();
	back_elements	= 0;

	function	OnSetup(item)
	{
		pos = ItemGetPosition(item);
		//character = SceneFindItem(g_scene, "character");
		//back_elements = SceneFindItem(g_scene, "back_elements_handler");
	}

	function	OnUpdate(item)
	{
		character_pos = ItemGetPosition(character);

		//if (Abs(pos.x - character_pos.x) > Mtr(3.0))
		/*{
			pos.x = Lerp(0.95, character_pos.x + Mtr(2.5), pos.x);
			pos.y = Lerp(0.95, character_pos.y - Mtr(1.0), pos.y);
			ItemSetPosition(item, pos);
			local back_elements_pos = ItemGetPosition(back_elements);
			back_elements_pos.x = pos.x * 0.5
			back_elements_pos.y = pos.y - Mtr(10.0)
			ItemSetPosition(back_elements, back_elements_pos);
		}*/
	}

}