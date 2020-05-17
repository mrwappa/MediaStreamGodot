extends Node2D

onready var videoPlayer = get_node("VideoPlayer")
onready var audioPlayer = get_node("AudioStreamPlayer")
var resources = preload("Resources.gd").new()

const transitionInterval = 3.0
var mediaSet = null

func newMediaSet():
	if(mediaSet):
		#Unload from memory
		mediaSet.art = null
		mediaSet.video = null
		mediaSet.music = null
		mediaSet = null
		pass
	mediaSet = resources.getMediaSet()
	videoPlayer.set_stream(mediaSet.video)
	audioPlayer.set_stream(mediaSet.audio)
	
	videoPlayer.musicInfo = { "art": mediaSet.art, "name": mediaSet.musicName, "album": mediaSet.albumName }
	videoPlayer.play()
	videoPlayer.set_autoplay(true)
	videoPlayer.set_volume(0)
	audioPlayer.play()
	audioPlayer.set_volume_db(0)
	pass

func _ready():
	set_process(true)
	
	var audioDevice = findAudioDeviceFile()
	AudioServer.set_device(audioDevice)
	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position((screen_size*0.5 - window_size*0.5) - Vector2(0,40))
	newMediaSet()
	pass

func _input(ev):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
		
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
		audioPlayer.stop()
		newMediaSet()
		pass
	pass

func _process(delta):
	var currentAudioDuration = audioPlayer.get_stream().get_length()
	var currentAudioPosition = audioPlayer.get_playback_position()
	#print(currentAudioDuration - currentAudioPosition)
	#print(resources.playlist.size())
	
	if(audioPlayer.is_playing()):
		videoPlayer.audioPosition = currentAudioPosition
		videoPlayer.audioLength = currentAudioDuration
		pass
	
	if((currentAudioDuration - currentAudioPosition) < 0.09): 
		audioPlayer.stop()
		newMediaSet()
		pass 
	if((currentAudioDuration - currentAudioPosition) < transitionInterval):
		videoPlayer.absoluteBoxAlpha = lerp(videoPlayer.absoluteBoxAlpha, 1, delta*1.5)
		pass
	else:
		videoPlayer.absoluteBoxAlpha = lerp(videoPlayer.absoluteBoxAlpha, 0, delta/transitionInterval)
		pass
	pass

func findAudioDeviceFile():
	var fileExtension = ".audioDevice"
	var dir = Directory.new()
	dir.open("res://")
	dir.list_dir_begin()
	var file = null
	
	while true:
		file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.find(fileExtension) > 0:
			break
	
	dir.list_dir_end()
	
	if(file == ""):
		var newAudioFile = "Default.audioDevice"
		var newFile = File.new()
		newFile.open(newAudioFile, File.WRITE)
		newFile.close()
		file = newAudioFile
		pass
	
	file = file.substr(0, file.length() - fileExtension.length())

	return file
	pass
