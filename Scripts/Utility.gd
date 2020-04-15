extends Node
var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()
	pass

func getRandomListItem(list) :
	return list[rng.randi_range(0, list.size() - 1)]
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
