//	Main project script

g_current_language
				<-	"uk"

Include ("scriptlib/nad.nut")
Include ("data/scripts/audio.nut")
Include ("data/scripts/ace_deleter.nut")
Include ("data/scripts/fx_functions.nut")
Include ("data/scripts/ui.nut")

g_debug			<-	false
g_renderer		<-	0
g_mixer			<-	0
g_audio			<-	0
g_project		<-	0
g_ui			<-	0

g_ace_deleter	<-	0

g_block_counter		<- 0
g_selection_counter	<- 0

function	g_script()
{
	return (ProjectGetScriptInstance(g_project))
}

g_renderer = EngineGetRenderer(g_engine)
g_mixer = EngineGetMixer(g_engine)

class	MainProject
{
	
	scene_list 		= [	{	name = "Language selection",	nms = "data/language.nms"},
						{	name = "Splash Screen",			nms = "data/splash.nms"},
						{	name = "Game Title",			nms = "data/title.nms"},
						{	name = "Level 0",		nms = "data/level_intro.nms"},
						{	name = "Level #0",				nms = "data/cavern_00.nms"}
					]

	current_scene	=	-1
	next_scene		=	0

	scene_2d		= 	-1

	scene_3d		=	0
	scene_3d_instance
					=	0

	function	OnSetup(project)
	{
		g_project = project
		g_audio = AudioPlayer()
		g_audio.Setup()
		g_ace_deleter = CommandListDeleter()
		
		//GoToLanguageSelection()
		//GoToSplashScreen()
		//GoToTitleScreen()
		GoToNextLevel()
	}
	
	function	GoToLanguageSelection()
	{	next_scene = 0	}	

	function	GoToSplashScreen()
	{	next_scene = 1	}

	function	GoToTitleScreen()
	{	next_scene = 2	}

	function	GoToNextLevel()
	{	
		if (current_scene < 3)
			next_scene = 3
		else
			next_scene++
	}
	
	function	GetCurrentLevelIntroTitle()
	{
		return (scene_list[current_scene].name)
	}

	function	OnUpdate(project)
	{
		MouseUpdate();

		if (next_scene != current_scene)
		{	
			//	Unload previous scene
			if (current_scene != -1)
				ProjectUnloadScene(g_project, scene_3d)
				
			if (scene_2d != -1)
				ProjectUnloadScene(g_project, scene_2d)
				
			//	Create Blank 2D layer
			scene_2d = ProjectInstantiateScene(g_project, "data/blank_ui.nms") //, ProjectInstantiateLayerFront)
			g_ui = ProjectSceneGetInstance(scene_2d)

			//	Load next scene
			current_scene = next_scene
			print("MainProject::OnUpdate() : Loading scene " + scene_list[current_scene].name)
			scene_3d = ProjectInstantiateScene(g_project, scene_list[current_scene].nms) //, ProjectInstantiateLayerBack)
			scene_3d_instance = ProjectSceneGetInstance(scene_3d)

			SceneSetup(scene_3d_instance)
			SceneReset(scene_3d_instance)

			// Setup all engine resources.
			EngineSetupResources(g_engine)
		}
	
		g_ace_deleter.Update()
	}
}