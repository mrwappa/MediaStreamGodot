extends Node

var utility = preload("Utility.gd").new()

const musicPath = "res://Music/"
const videoPath = "res://Videos/"

var musicFolders = []
var videoFolders = []
var musicDictionary = {}
var videoDictionary = {}
var artDictionary = {}

const targetFolder = "Attack on Titan"

var playlist = []

func _init():
	loadMusicAndArt()
	loadVideos()
	randomize()
	playlist.shuffle()
	pass

func getMediaSet():
	var folder = utility.getRandomListItem(musicFolders) if targetFolder == "" else targetFolder
	
	var musicFile = utility.getRandomListItem(musicDictionary[folder])
	var musicAsset = load(musicPath + folder + "/" + musicFile)
	
	var artFile = artDictionary[folder];
	var artAsset = load(musicPath + folder + "/" + artFile)
	
	var videoFile = utility.getRandomListItem(videoDictionary[folder])
	var videoAsset = null
	var rerouteIndex = videoFile.find(".reroute");
	
	if(rerouteIndex != -1):
		var videoFolder = videoFile.substr(0,rerouteIndex)
		videoFile = utility.getRandomListItem(videoDictionary[videoFolder])
		videoAsset = load(videoPath + videoFolder + "/" + videoFile)
		pass
	else:
		videoAsset = load(videoPath + folder + "/" + videoFile)
		pass

	var extensionLength = 4
	var firstLetterIndex = utility.findFirstLetter(musicFile)
	var musicName = musicFile.substr(firstLetterIndex, musicFile.length() - firstLetterIndex - extensionLength)
	
	return {"video": videoAsset, "audio": musicAsset, "art": artAsset, "musicName" : musicName, "albumName": folder}
	pass

func loadMusicAndArt(): 
	musicFolders = utility.listFilesInDirectory(musicPath)
	
	for folder in musicFolders:
		var files = utility.listFilesInDirectory(musicPath + folder)
		musicDictionary[folder] = []
		for file in files: 
			if file.find(".ogg") != -1:
				musicDictionary[folder].push_back(file)
				playlist.push_back(musicPath + folder + "/" + file)
				pass
			elif file.find("art.png") != -1 or file.find("art.jpg") != -1:
				artDictionary[folder] = file
				pass	
		pass

	pass
	
func loadVideos():
	videoFolders = utility.listFilesInDirectory(videoPath)
	
	for folder in videoFolders:
		var files = utility.listFilesInDirectory(videoPath + folder)
		videoDictionary[folder] = files
		pass
	pass
