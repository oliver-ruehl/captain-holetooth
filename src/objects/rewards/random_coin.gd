extends Node2D

signal taken

@onready var anim = get_node("anim")
@onready var sfx = get_node("sfx")
@onready var sprite = get_node("sprite")

func _ready():
	print("=== random_coin ready at: ", position)
	randomize_appearance()

func randomize_appearance():
	# Randomly pick a texture from 1.png to 12.png
	var texture_num = randi() % 12 + 1
	var texture_path = "res://src/objects/rewards/" + str(texture_num) + ".png"

	var texture = load(texture_path)
	if texture:
		sprite.texture = texture
		print("=== Loaded reward texture: ", texture_num)
	else:
		print("=== ERROR: Could not load texture: ", texture_path)
		return

	# Randomly pick a frame from 0-3 (each sprite sheet has 4 frames)
	var frame_num = randi() % 4
	sprite.frame = frame_num
	print("=== Set frame to: ", frame_num)

func take():
	print("=== take() called")
	if sfx:
		print("=== Playing sfx")
		sfx.play()
	else:
		print("=== WARNING: No sfx node found!")

	if anim:
		print("=== Playing 'taken' animation")
		anim.play("taken")
	else:
		print("=== WARNING: No anim node found!")

	print("=== Emitting taken signal")
	taken.emit()
