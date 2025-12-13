extends Area2D

# Flying NPC Properties
@export var movement_speed = -80 # Movement speed
@export var random_y_range = 10 # The range in Y axis that it can move
@export var motion = "linear" # "linear" or "zigzag"
@export var destroy_sound = "none" # "none" or "explode"
@export var group = "none" # "none", "enemy", or "pickup" - Allow you to quickly set group

# Animation player
@onready var anim_player = get_node("anim_player")

# Whether or not hitting this npc will result into resetting your bonus points
@export var reset_bonus = true

# Controller to prevent destroy() running twice
var destroyed = false

# Movement speed
var speed = Vector2()
var extra_motion = Vector2()

# Player Ship Type
const ship_type = preload("res://src/actors/player/ship/ship.gd")

# Start
func _ready():
	# Set group if selected
	if group != "none":
		add_to_group(group)

	# Set speed
	speed = Vector2(movement_speed, randf_range(-random_y_range, random_y_range))


# Processing
func _process(delta):
	# Moving the ship
	translate((speed + extra_motion) * delta)


# Destroy ship
func destroy(other):
	# Prevent this from running again once it has been destroyed
	if destroyed:
		return

	# Set destroyed as true
	destroyed = true

	# If the flying NPC hit the player ship, reset bonus scores
	#if reset_bonus && other extends ship_type:
	#	game.reset_bonus_score()

	# Create an explosion sound
	if destroy_sound == "explode":
		get_node("sfx").play("cork_pop")

	# Stop processing
	set_process(false)

	# Play the explosion animation from our anim_player
	anim_player.play("explode")
	await anim_player.animation_finished

	# Remove from game and memory
	queue_free()


# When the flying NPC enters the screen
func _on_visibility_enter_screen():
	# Enable processing
	set_process(true)

	# If we are using zigzag motion
	if motion == "zigzag":
		anim_player.play(motion)

	# Make sure to enable monitoring and monitorable
	monitoring = true
	monitorable = true


# When the NPC leaves the screen: Remove from game and memory
func _on_visibility_exit_screen():
	queue_free()
