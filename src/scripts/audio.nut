//

class	AudioPlayer
{
	track				= 0
	
	sfx_info			= 0
	sfx_validate		= 0
	sfx_proceed			= 0
	sfx_error			= 0
	

	constructor()
	{
		track = {	
					music		= 0,
					ui			= 1
				} 
	}
	
	function	PlayerLoadSound(_filename)
	{
		local	_filepath = "data/sfx/" + _filename
		if (FileExists(_filepath))
		{
			print("AudioPlayer::PlayerLoadSound() loading '" + _filepath + "'.")
			return EngineLoadSound(g_engine, _filepath)
		}
		else
		{
			print("AudioPlayer::PlayerLoadSound() cannot find '" + _filepath + "' !!!")
			return 0
		}
	}
	
	function	Setup()
	{
		//	Preload sounds
		sfx_validate 	= PlayerLoadSound("sfx_validate.wav")
		sfx_proceed		= PlayerLoadSound("sfx_proceed.wav")
		sfx_error		= PlayerLoadSound("sfx_error.wav")
		sfx_info		= PlayerLoadSound("sfx_info.wav")

		//	Allocate channels
		//	Music Channel
		if (!MixerChannelTryLock(g_mixer, track.music))
			print("MusicPlayer::PlayerLoopStream() !! Cannot lock channel " + track.music)
		else
		{			
			MixerChannelSetLoopMode(g_mixer, track.music, LoopRepeat)
			MixerChannelSetGain(g_mixer, track.music, 1.0)
			MixerChannelSetPitch(g_mixer, track.music, 1.0)
		}
	
		//	UI message Channel
		if (!MixerChannelTryLock(g_mixer, track.ui))
			print("MusicPlayer::PlayerLoopStream() !! Cannot lock channel " + track.ui)
		else
		{			
			MixerChannelSetLoopMode(g_mixer, track.ui, LoopNone)
			MixerChannelSetGain(g_mixer, track.ui, 1.0)
			MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		}
	}

	function	PlaySplashScreenSound()
	{
		PlayUIStream("data/sfx/sfx_splash_screen.ogg")
	}

	function	PlayBoatStream(_stream_file)
	{
		//MixerChannelStop(g_mixer, track.boat)
		local _ch = MixerStreamStart(g_mixer, _stream_file) //MixerChannelStartStream(g_mixer, track.boat, _stream_file)
		MixerChannelSetPitch(g_mixer, _ch, Rand(0.7, 1.3))
		MixerChannelSetGain(g_mixer, _ch, Rand(0.9, 1.1))
	}
		
	function	PlayUIStream(_stream_file)
	{
		MixerChannelStop(g_mixer, track.ui)
		MixerChannelStartStream(g_mixer, track.ui, _stream_file)
		MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		MixerChannelSetGain(g_mixer, track.ui, 0.25)
	}
	
	function	PlayUISound(_sound)
	{
		MixerChannelStop(g_mixer, track.ui)
		MixerChannelStart(g_mixer, track.ui, _sound)
		MixerChannelSetPitch(g_mixer, track.ui, 1.0)
		MixerChannelSetGain(g_mixer, track.ui, 0.25)
	}

	function	PlayMusicTitle()
	{
		MixerChannelStop(g_mixer, track.music)
		MixerChannelStartStream(g_mixer, track.music, "data/sfx/track_00.ogg")
		MixerChannelSetLoopMode(g_mixer, track.music, LoopRepeat)
		MixerChannelSetPitch(g_mixer, track.music, 1.0)
		MixerChannelSetGain(g_mixer, track.music, 0.75)
	}

	function	StopMusic()
	{	MixerChannelStop(g_mixer, track.music)	}

	
	function	UIInfo()
	{
		PlayUISound(sfx_info)
	}
	
	
	function	UIValidate()
	{
		PlayUISound(sfx_validate)
	}
	
	function	UIProceed()
	{
		PlayUISound(sfx_proceed)
	}
	
	function	UIWarn()
	{
		PlayUISound(sfx_proceed)
	}
}