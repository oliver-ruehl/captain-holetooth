extends Control

# Game Title
@export var game_title_path: NodePath
@onready var game_title = get_node(game_title_path)

# Menu Buttons
@export var menu_buttons_path: NodePath
@onready var menu_buttons = get_node(menu_buttons_path)

# Options Screen
@export var options_screen_path: NodePath
@onready var options_screen = get_node(options_screen_path)

# Music Player
@export var music_player_path: NodePath
@onready var music_player = get_node(music_player_path)

# Music Volume Slider
@export var music_volume_slider_path: NodePath
@onready var music_volume_slider = get_node(music_volume_slider_path)

# Animations
@export var animations_path: NodePath
@onready var animations = get_node(animations_path)

# Current Language Locale
var current_locale = TranslationServer.get_locale()


# -- START --
func _ready():
	# Update music player volume the initial music volume stored in global
	if music_volume_slider and Global.music:
		music_volume_slider.value = Global.music.volume * 100

	var start_btn = get_node_or_null("menu_buttons/startbutton")
	if start_btn:
		start_btn.grab_focus()


# -- BUTTON PRESSES --
# Start Game
func _on_startbutton_pressed():
	SceneTransition.fade_to("res://src/screens/intro/intro.tscn")
	get_node("sfx").play("click")

# Options
func _on_optionsbutton_pressed():
	if options_screen:
		options_screen.show()
		set_process_input(true)
	get_node("sfx").play("click")

# Exit
func _on_exitbutton_pressed():
	if options_screen:
		options_screen.hide()
		set_process_input(false)
	var start_btn = get_node_or_null("menu_buttons/startbutton")
	if start_btn:
		start_btn.grab_focus()
	get_node("sfx").play("click")

# Close Options
func _on_btn_close_options_pressed():
	if options_screen:
		options_screen.hide()
	get_node("sfx").play("click")

# Change Language to German
func _on_de_button_pressed():
	get_node("sfx").play("click")
	TranslationServer.set_locale("de_DE")
	get_tree().reload_current_scene()


# Change Language to English
func _on_en_button_pressed():
	get_node("sfx").play("click")
	TranslationServer.set_locale("en_GB")
	get_tree().reload_current_scene()


 #-- MUSIC --
 #Updates global music volume when slider has been changed

func _on_music_volume_value_changed( value ):
	# Set global music volume
	if Global.music:
		Global.music.volume = value/100

	# Update music player volume
	if music_player:
		music_player.volume_db = linear_to_db(Global.music.volume)


# -- DEBUG --
# DEBUG: Jump to scene 3
func _on_jump_scn3_pressed():
	SceneTransition.fade_to("res://src/levels/forest/forest.tscn")

# DEBUG: Jump to scene 4
func _on_jump_scn4_pressed():
	SceneTransition.fade_to("res://src/levels/mountain/mountain.tscn")

# DEBUG: Jump to scene 5
func _on_jump_scn5_pressed():
	SceneTransition.fade_to("res://src/levels/flyhome/flyhome.tscn")

# DEBUG: Jump to minigame
func _on_jump_minigame_pressed():
	SceneTransition.fade_to("res://src/levels/minigames/yankandy/yankandy.tscn")

func _on_jump_castle_pressed():
	SceneTransition.fade_to("res://src/levels/castle/castle_outside.tscn")

func _on_donate_button_pressed():
	OS.shell_open("https://www.patreon.com/hirnbix")


func _on_playtime_confirm_pressed():
	# Path might need fixing in scene
	var input = get_node_or_null("options_screen/settings/Parental Controls/playtime_settings/playtime_limit")
	if input and Global.music:
		Global.playtime_limit_minutes = input.text
		Global.playtime_limit_seconds = int(Global.playtime_limit_minutes) * 60


func _on_charactercardsbutton_pressed():
	SceneTransition.fade_to("res://src/screens/character-cards/character-cards.tscn")

func _on_candy_skull_button_pressed():
	if animations:
		# Play the wigglecandy animation once (avoid infinite reconnection)
		animations.play("wigglecandy")
