extends Node

var Prefs:Dictionary = {}

func save_to_disk(fp, ignore=[]):
	if !(ignore is Array):
		return
	##
	
	var contents = Prefs.duplicate(true)
	
	for i in ignore:
		contents.erase(i)
	##
	
	var file = FileAccess.open(fp, FileAccess.WRITE)
	file.store_line(JSON.stringify(contents))
	file.close()
##

func load_from_disk(fp):
	var file = FileAccess.open(fp, FileAccess.READ)
	if not file or file == null:
		return
	##
	if FileAccess.file_exists(fp):
		if not file.eof_reached():
			Prefs = JSON.parse_string(file.get_line())
		##
	##
##
