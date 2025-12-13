extends Control

func _ready():
	pass

func _on_TextureButton_pressed():
	Transition.fade_to("res://src/screens/menu/menu.tscn")
	print("Debug: Jumping to Menu")
