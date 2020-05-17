extends Node
var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()
	pass

func getRandomListItem(list) :
	return list[rng.randi_range(0, list.size() - 1)]
	pass
	
func randIRange(from, to):
	return rng.randi_range(from, to)
	pass

func listFilesInDirectory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.find(".import") == -1:
			files.append(file)

	dir.list_dir_end()

	return files
	pass
	
func findExtensionFile(fileExtension, defaultFile):
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
		var newFile = File.new()
		newFile.open(defaultFile, File.WRITE)
		newFile.close()
		file = defaultFile
		pass
	
	file = file.substr(0, file.length() - fileExtension.length())

	return file
	pass

func characterIs(character,string): 
	for aChar in string:
		if(character == aChar):
			return true
		pass
	return false
	pass

func findFirstLetter(string):
	var index = 0
	for character in string:
		if(not character.is_valid_integer() and !characterIs(character,",.- ")):
			return index
			pass
		index += 1
		pass
	pass
