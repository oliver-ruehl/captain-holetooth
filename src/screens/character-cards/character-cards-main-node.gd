extends Control

func _ready():
	# The card container handles population in its _ready()
	# Just ensure we have at least the default character
	if Global.characters_met.is_empty():
		Global.characters_met = ["Captain Holetooth"]

func _on_TextureButton_pressed():
	SceneTransition.fade_to("res://src/screens/menu/menu.tscn")
	print("Debug: Jumping to Menu")
