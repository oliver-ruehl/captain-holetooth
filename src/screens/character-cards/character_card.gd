extends Node2D

# animation Node
@onready var anim = get_node("AnimationPlayer")

# Get node
@export var button_path: NodePath
@onready var button = get_node(button_path)

# Start
func _ready():

	# Create connetion for TOGGLE
	button.toggled.connect(on_toggled)

	# Create connection for normal button
	button.pressed.connect(on_pressed)

	# Set toggle mode
	button.toggle_mode = true


# On button toggle
func on_toggled(pressed):
	if(pressed):
		pass

	else:
		anim.play_backwards("flip_card")

# On button pressed
func on_pressed():
	anim.play("flip_card")
