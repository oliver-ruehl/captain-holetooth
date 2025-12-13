extends Node

const PATH = "user://savegame.json"

var db = {}
func _ready():
	set_process_input(true)
	
func _input(e):
	if e.is_action_pressed("reload") and Global.debug_mode:
		Global.score = 0
		db = {}
		
func _enter_tree():
	load_game()

func _exit_tree():
	save_game()

func set_key(key, value):
	db[key] = value

func get_key(key, default=null):
	if db.has(key):
		return db[key]
	else:
		return default
	
func load_game():
	if !FileAccess.file_exists(PATH):
		print("No saved game found")
		return
	
	var file = FileAccess.open(PATH, FileAccess.READ)
	if file == null:
		print("Error opening save file")
		return
	
	var text = file.get_as_text()
	if text:
		var json = JSON.new()
		if json.parse(text) == OK:
			if typeof(json.data) == TYPE_DICTIONARY:
				db = json.data

func save_game():
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(db))
		print("Game saved to " + PATH)
	
func remove_save():
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	if file:
		file.store_string("")
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit() # default behavior
