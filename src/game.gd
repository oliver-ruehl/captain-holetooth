extends Node

signal scores_changed

# Game prefs
const SAVE = "user://savegame.json"
const MAX_SCORE_PER_ITEM = 0 # 0 is infinity
const MAX_ITEMS = 120

# HUD and scoring
var score = 0
var score_per_item = 1
var high_score = 0
var items_collected = 0

# Scene related
var currentScene = null
var opened_scenes = []

var db = {}

func _enter_tree():
	set_process_input(true)
	load_game()
	
func _input(event):
	if event.is_action_pressed("reload") and Global.debug_mode:
		score = 0
		if db.size():
			db = {"high_score":db["high_score"]} # save only high_score on reload
		else:
			db = {"high_score": 0}
		save_game()
		load_game()
		scores_changed.emit()
		get_tree().reload_current_scene()

func _exit_tree():
	save_game()

func save_key(key, value):
	db[key] = value

func load_key(key, default=null):
	if db.has(key):
		return db[key]
	else:
		return default
	
func load_game():
	if !FileAccess.file_exists(SAVE):
		print("No saved game found")
		return

	var file = FileAccess.open(SAVE, FileAccess.READ)
	if file == null:
		print("Error opening save file: " + str(FileAccess.get_open_error()))
		return
	
	var text = file.get_as_text()
	if text:
		var json = JSON.new()
		var error = json.parse(text)
		if error == OK:
			if typeof(json.data) == TYPE_DICTIONARY:
				db = json.data
		else:
			print("JSON Parse Error: ", json.get_error_message())
		
	items_collected = load_key("items_collected", 0)
	high_score = load_key("high_score", 0)
	opened_scenes = load_key("opened_scenes", [])

func save_game():
	var file = FileAccess.open(SAVE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(db))
		print("Game saved to " + SAVE)
	
func remove_save():
	var file = FileAccess.open(SAVE, FileAccess.WRITE)
	if file:
		file.store_string("")
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()
		
		
func collect_item():
	items_collected += 1
	save_key("items_collected", items_collected)
	
	score += score_per_item
	if score > high_score:
		save_key("high_score", score)
		high_score = score

	scores_changed.emit()
	if MAX_SCORE_PER_ITEM == 0 or score_per_item <= MAX_SCORE_PER_ITEM:
		score_per_item += 1

func reset_bonus_score():
	score_per_item = 1

func open_scene(scene_name):
	if !is_scene_opened(scene_name):
		opened_scenes.append(scene_name)
		save_key("opened_scenes", opened_scenes)

func is_scene_opened(scene_name):
	return opened_scenes.find(scene_name) >= 0


# returns timer you can await for, eg:
# await Game.timer(0.5).timeout
func timer(time):
	var t = Timer.new()
	t.wait_time = time
	add_child(t)
	t.start()
	t.timeout.connect(t.queue_free)
	return t
