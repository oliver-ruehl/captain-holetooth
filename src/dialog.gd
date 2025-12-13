extends NinePatchRect

# SOLOGUE - a small dialog system
# Ported to Godot 4

##################
#  Dialogs       #
##################

var dialog_yan = [
"OH CAPTAIN",
"DIDN'T EXPECT/d020.../d005/bYOU /rHERE.",
"I'M COLLECTING MUSHROOMS.",
"I HEARD A CRASH NOISE.",
"GO /s< LEFT /rHERE.",
"YOU WILL FIND THE MOUNTAIN.",
"GOOD LUCK."]

var dialog_rootninja = [
"Uh oh... i found this thing down here...",
"Yes. Well... That's the wing I was looking for!",
"Good. Uh. Good. Go. Now. Busy digging.",
"Sure, bye Rootninja!" ]


const DEFAULT_FONT_SIZE = 45
const DEFAULT_DELAY     = 0.05
const TEXT_DELAY        = 1
const TEXT_SHAKE        = 2
const TEXT_WAVE         = 4
const TEXT_BOUNCE       = 8
const TEXT_RESET        = 0

var font           = preload("res://src/fonts/dialog-berry8.tres")
var font_size      = DEFAULT_FONT_SIZE
var portrait
var color          = Color(0,0,0)
var input_dialog   = []
var current_string = ""
var tag            = ""
var mods           = []
var active_mods    = 0
var progress       = -1
var char_pos       = 0
var text_offset    = Vector2(15,44)
var char_amt       = 0
var line_amt       = 0
var cutoff         = 0
var delay          = DEFAULT_DELAY
var time           = 0.0
var counter        = 0.0
var visible_flag   = true # 'visible' is a member of CanvasItem
var continuous     = true
var running        = true
var cut            = false
var line_done      = true
var finished       = true
var has_tag        = false

signal dialog_start
signal dialog_continue
signal dialog_end

func _ready():
	for actor in get_tree().get_nodes_in_group("actors"):
		var actor_node_path = actor.get_path()
		print(actor_node_path)
		var _actor_node = get_node(actor_node_path)

	char_amt = 255
	line_amt = 5
	print(char_amt, " ", line_amt)
	print(dialog_yan)
	set_process(true) # In Godot 4 we use _process instead of _fixed_process for this usually, or _physics_process

func _unhandled_key_input(_key_event):
	next_line()

func _draw():
	if visible_flag:
		var place = 0
		var character
		var origin = 0
		var pos = Vector2(12, 12)
		var char_size

		active_mods = 0

		if has_tag:
			draw_string(font, text_offset, "[" + tag + "]: ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

		while place < char_pos:
			character = current_string.substr(place, 1)
			origin = int(char_amt * floor(place/float(char_amt)))
			char_size = font.get_string_size(current_string.substr(origin, place % char_amt), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
			pos.x = text_offset.x + char_size.x
			pos.y = text_offset.y + (char_size.y * floor(place/float(char_amt) + int(has_tag)))

			if typeof(mods[place]) == TYPE_ARRAY:
				active_mods = mods[place][0]

			if active_mods == 0 or active_mods == TEXT_DELAY:
				draw_string(font, pos, character, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
				place += 1
				continue

			if active_mods & TEXT_SHAKE:
				var num = 0.7
				pos += Vector2(randf_range(-num, num), randf_range(-num, num))
			if active_mods & TEXT_WAVE:
				pos.y += 2 * sin((time*5) + (place*0.4))
			if active_mods & TEXT_BOUNCE:
				pos.y += abs(4 * sin((time*5) + (place*0.5))) - 4
			draw_string(font, pos, character, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
			place += 1


func _process(delta):
	if running and !finished and !line_done:
		if counter >= delay:
			if char_pos < current_string.length():
				if typeof(mods[char_pos]) == TYPE_ARRAY:
					if mods[char_pos][0] & TEXT_DELAY:
						delay = mods[char_pos][1]

				char_pos += 1
			else:
				line_done = true

			if !continuous:
				queue_redraw()
			counter = 0
		counter += delta

	time += delta

	if continuous:
		queue_redraw()


func run_dialog(dialog):
	if typeof(dialog) == TYPE_ARRAY and finished:
		input_dialog = dialog
		finished = false
		time = 0.0
		emit_signal("dialog_start")
		next_line()


func next_line():
	if line_done and !finished:
		progress += 1

		if progress < input_dialog.size():
			var item = input_dialog[progress]
			char_pos = 2
			mods.clear()

			if typeof(item) == TYPE_ARRAY:
				has_tag = true
				tag = item[0]
				if typeof(item[1]) == TYPE_INT:
					font_size = item[1]
					current_string = process_text(item[2])
				else:
					font_size = DEFAULT_FONT_SIZE
					current_string = process_text(item[1])
			else:
				has_tag = false
				font_size = DEFAULT_FONT_SIZE
				delay = DEFAULT_DELAY
				current_string = process_text(item)

			line_done = false
			emit_signal("dialog_continue")

		elif progress == input_dialog.size():
			char_pos = 0
			current_string = ""
			tag = ""
			input_dialog.clear()
			mods.clear()
			has_tag = false
			finished = true
			progress = -1
			queue_redraw()
			emit_signal("dialog_end")
			print("Dialogue finished!")


func process_text(string):
	var i = 0
	var mod_count = 0
	var new_string = string
	mods.resize(new_string.length())

	while i != -1:
		mod_count = 0
		i = new_string.find("/", i)

		if i != -1:
			if typeof(mods[i]) != TYPE_ARRAY:
				mods[i] = [0, 0]
			if new_string.substr(i + 1, 1) == "d":
				mods[i][0] += TEXT_DELAY
				mods[i][1] = float(new_string.substr(i + 2, 3)) / 100
				mod_count += 4
			elif new_string.substr(i + 1, 1) == "s":
				mods[i][0] += TEXT_SHAKE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "w":
				mods[i][0] += TEXT_WAVE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "b":
				mods[i][0] += TEXT_BOUNCE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "r":
				mods[i][0] = TEXT_RESET
				mod_count += 1
			new_string.erase(i, 1+mod_count)

	return new_string


func set_visibility(toggle):
	if typeof(toggle) == TYPE_BOOL:
		visible_flag = toggle
		queue_redraw()
