//

class	LevelIntro
{
	
	intro_ui	= 0
	
	timeout		= 0.0
	
	text_shown	= false

	function	OnSetup(scene)
	{
		timeout = g_clock
		intro_ui = LevelIntroUI()
	}

	function	OnUpdate(scene)
	{
//g_script().GoToNextLevel()
		local	_sync = TickToSec(g_clock - timeout)
		
		if ((!text_shown) && (_sync > Sec(0.125)))
		{
			intro_ui.FadeIn()
			text_shown = true
		}
		
		
		if (_sync > Sec(4.0))
		{
			g_script().GoToNextLevel()
		}
		
	}
}