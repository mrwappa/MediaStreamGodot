extends Node

var utility = preload("Utility.gd").new()

const mediaFolder = "Games"

var musicPath = "res://Media/" + mediaFolder + "/Music/"
var videoPath = "res://Media/" + mediaFolder + "/Videos/"

var musicFolders = []
var videoFolders = []
var musicDictionary = {}
var videoDictionary = {}
var videoDictionaryIndex = {}
var artDictionary = {}

const targetFolder = ""

var contentFolderStartIndex = 19 + mediaFolder.length()

var firstSong = true

var playlist = []

func loadAllMedia():
	loadMusicAndArt()
	loadVideos()
	print(playlist.size())
	pass

func _init():
	if(targetFolder != ""):
		playlist.invert()
		pass 
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
	
	##GET VIDEO
	var folderName = contentFolder if (musicObj.subFolder == null) else contentFolder + "/" + musicObj.subFolder
	var rerouteIndex = videoDictionary[folderName][0].find(".reroute")
	
	if(rerouteIndex != -1):
		var rerouteFolder = videoDictionary[folderName][0].substr(0,rerouteIndex)
		folderName = rerouteFolder if (musicObj.subFolder == null) else rerouteFolder + "/" + musicObj.subFolder
		
		pass
	var videoIndex = videoDictionaryIndex[folderName]
	if(videoIndex > videoDictionary[folderName].size() - 1):
		videoIndex = 0
		videoDictionaryIndex[folderName] = 0
		pass
	
	var videoFile = videoDictionary[folderName][videoIndex]
	videoDictionaryIndex[folderName] = videoIndex + 1
	videoAsset = load(videoPath + folderName + "/" + videoFile)
	##GET VIDEO
	
	if (playlist.size() == 1):
		playlist.pop_back()
		loadAllMedia()
		pass
	else:
		playlist.pop_back()
		pass
		
	return {"video": videoAsset, "audio": musicAsset, "art": artAsset, "musicName" : musicName, "albumName": contentFolder}
	pass

func loadMusicAndArt(): 
	randomize()
	musicFolders = utility.listFilesInDirectory(musicPath)
	musicFolders.shuffle()
	for folder in musicFolders:
		var files = utility.listFilesInDirectory(musicPath + folder)
		files.shuffle()
		musicDictionary[folder] = []
		for file in files: 
			if(file.find(".ogg") != -1):
				musicDictionary[folder].push_back({ "path": musicPath + folder + "/" + file, "subFolder": null })
				pass
			elif(file.find("art.png") != -1 or file.find("art.jpg") != -1):
				artDictionary[folder] = file
				pass
			else:
				var subFolderFiles = utility.listFilesInDirectory(musicPath + folder + "/" + file)
				for subFile in subFolderFiles:
					if (subFile.find(".ogg") != -1):
						musicDictionary[folder].push_back({ "path": musicPath + folder + "/" + file + "/" + subFile, "subFolder": file })
						pass
					pass
			pass
		pass
		musicDictionary[folder].shuffle()
	pass
	
	while musicDictionary.size() > 0:
		for folder in musicDictionary:
			var currentFolder = musicDictionary[folder]
			#print(folder)
			if(currentFolder.size() == 0):
				musicDictionary.erase(folder)
				break
				pass
			if(currentFolder.size() <= 3):
				playlist = playlist + musicDictionary[folder]
				musicDictionary.erase(folder)
				break
				pass
			if(currentFolder.size() > 3):
				var randomIndex = utility.randIRange(0,max(playlist.size() - 1,0))
				playlist.insert(randomIndex, musicDictionary[folder].pop_back())
				playlist.insert(randomIndex, musicDictionary[folder].pop_back())
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
				videoDictionaryIndex[folder + "/" + subFolder] = 0
				pass
			pass
		else:
			videoDictionary[folder] = files
			videoDictionaryIndex[folder] = 0
			pass
		pass
	pass
