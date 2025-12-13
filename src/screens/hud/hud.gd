extends CanvasLayer

@export var collected_text: NodePath
@export var score_text: NodePath
@export var highscore_text: NodePath
@export var sound_off_button: NodePath

@onready var animations = get_node("animations")
@onready var yan = get_parent().find_child("Yan", true, false)

func _ready():
	if yan && Global.last_pos[0] == Vector2(0,0):
		yan.met_yan.connect(_on_met_yan)
	set_process_input(true)
	update_scores()
	Game.scores_changed.connect(update_scores)
	# Ensure audio is unmuted on startup
	AudioServer.set_bus_mute(0, false)
	update_sound_hud()

func _on_met_yan():
	get_node("sfx").play("card_unlock")
	animations.play("yan_unlock_anim")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_go_to_menu_pressed()

# Update scores
func update_scores():
	get_node(collected_text).text = str(Game.items_collected)
	get_node(score_text).text = str(Game.score)
	get_node(highscore_text).text = str(Game.high_score)

func _on_go_to_menu_pressed():
	Transition.fade_to("res://src/screens/menu/menu.tscn")


# Toggles music on/off while keeping the stored volume that may have been set elsewhere
func _on_sound_off_pressed():
	# Turns off music completely, or returns it back to normal
	if(Global.music.enabled):
		# AudioServer.set_stream_global_volume_scale(0) # Deprecated in 4
		AudioServer.set_bus_mute(0, true)
	else:
		# AudioServer.set_stream_global_volume_scale(Global.music.volume)
		AudioServer.set_bus_mute(0, false)

	# Toggle bool
	Global.music.enabled = not Global.music.enabled

	# Update sound HUD
	update_sound_hud()


# Updates sound HUD
func update_sound_hud():
	if(Global.music.enabled):
		get_node(sound_off_button).button_pressed = true
	else:
		get_node(sound_off_button).button_pressed = false
