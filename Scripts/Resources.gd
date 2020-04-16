extends Node

var utility = preload("Utility.gd").new()

const musicPath = "res://Music/"
const videoPath = "res://Videos/"

var musicFolders = []
var videoFolders = []
var musicDictionary = {}
var videoDictionary = {}
var artDictionary = {}

const targetFolder = "Gurren Lagann"

const contentFolderStartIndex = 12

var firstSong = true

var playlist = []

func loadAllMedia():
	loadMusicAndArt()
	loadVideos()
	randomize()
	playlist.shuffle()
	pass

func _init():
	loadAllMedia()
	pass

func getMediaSet():
	
	var musicObj = null
	if(targetFolder == ""):
		musicObj = playlist[playlist.size() - 1]
		pass
	else:
		for item in playlist:
			if(item.path.find(targetFolder) != -1):
				musicObj = item
				break
				pass
			pass
		pass
	
	var fullPath = musicObj.path
	
	var musicFileIndex = fullPath.rfind("/")
	var musicFile = fullPath.substr(musicFileIndex + 1, fullPath.length() - musicFileIndex)
	var extensionLength = 4
	var firstLetterIndex = utility.findFirstLetter(musicFile)
	var musicName = musicFile.substr(firstLetterIndex, musicFile.length() - firstLetterIndex - extensionLength)
	
	var contentFolderEndIndex = fullPath.find("/",contentFolderStartIndex)
	var contentFolder = fullPath.substr(contentFolderStartIndex,contentFolderEndIndex - contentFolderStartIndex)
	
	var artFile = artDictionary[contentFolder];
	
	var artAsset = load(musicPath + contentFolder + "/" + artFile)
	var musicAsset = load(fullPath)
	var videoAsset = null
	
	var videoFile = utility.getRandomListItem(videoDictionary[contentFolder]) if (musicObj.subFolder == null) else (musicObj.subFolder + "/" + utility.getRandomListItem(videoDictionary[contentFolder + "/" + musicObj.subFolder]))
	
	var rerouteIndex = videoFile.find(".reroute")
	if(rerouteIndex != -1):
		var videoFolder = videoFile.substr(0,rerouteIndex)
		videoFile = utility.getRandomListItem(videoDictionary[videoFolder])
		videoAsset = load(videoPath + videoFolder + "/" + videoFile)
		pass
	else:
		videoAsset = load(videoPath + contentFolder + "/" + videoFile)
		pass
	
	if (playlist.size() == 1):
		loadAllMedia()
		pass
	else:
		playlist.pop_back()
		pass
		
	return {"video": videoAsset, "audio": musicAsset, "art": artAsset, "musicName" : musicName, "albumName": contentFolder}
	pass

func loadMusicAndArt(): 
	musicFolders = utility.listFilesInDirectory(musicPath)
	
	for folder in musicFolders:
		var files = utility.listFilesInDirectory(musicPath + folder)
		musicDictionary[folder] = []
		for file in files: 
			if(file.find(".ogg") != -1):
				playlist.push_back({ "path": musicPath + folder + "/" + file, "subFolder": null })
				pass
			elif(file.find("art.png") != -1 or file.find("art.jpg") != -1):
				artDictionary[folder] = file
				pass
			else:
				var subFolderFiles = utility.listFilesInDirectory(musicPath + folder + "/" + file)
				for subFile in subFolderFiles:
					if (subFile.find(".ogg") != -1):
						playlist.push_back({ "path": musicPath + folder + "/" + file + "/" + subFile, "subFolder": file })
						pass
					pass
				pass
		pass
	pass
	
func loadVideos():
	videoFolders = utility.listFilesInDirectory(videoPath)
	
	for folder in videoFolders:
		var files = utility.listFilesInDirectory(videoPath + folder)
		if(files[0].find(".") == -1):
			for subFolder in files:
				var subFolderFiles = utility.listFilesInDirectory(videoPath + folder + "/" + subFolder)
				videoDictionary[folder + "/" + subFolder] = subFolderFiles
				pass
			pass
		else:
			videoDictionary[folder] = files
			pass
		
		pass
	pass
