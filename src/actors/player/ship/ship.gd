extends Area2D

# Max Speed
const MAX_SPEED = 250

# Time in Seconds the speed boost lasts
const SPEED_BOOST_TIME = 2 # seconds
const SPEED_BOOST_MULTIPLIER = 1.5 # 1.5x speed multiplier
var speed_boost = 1 # This changes to the multiplier when boost is enabled

const ACC_BOOST_TIME = 5 # seconds
const ACC_BOOST_MULTIPLIER = 7.5 # 7.5x more ship control!
var acc_boost = 1

# Acceleration
const ACCELERATION = 950 # Higher acceleration gives the player quicker control over the ship

# Animation player
@export var anim_player_path: NodePath
@onready var anim_player = get_node(anim_player_path)

# Screen Size is used to determine where the player can fly
var screen_size
var prev_shooting = false
var killed = false
var speed = Vector2(0, 0)

# animated from anim when hit
var motion_factor = Vector2(1, 1) # multiplies base motion
var root_motion = Vector2(0, 0) # applied to base motion

# Shoot delay
var shoot_delay_sec = 0.08

# Processing
func _process(delta):
	# Player motion
	var motion = Vector2()

	# Input: MOVE UP
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	# Input: MOVE DOWN
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	# Input: MOVE LEFT
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	# Input: MOVE RIGHT
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
	# Input: SHOOT
	if Input.is_action_pressed("ui_accept") && timer.get_time_left() <= 0:
		timer.start()
		# Create a new bullet instance
		var bullet = preload("res://src/actors/player/bullet.tscn").instantiate()

		# Use the Position2D as spawn coordinate for our new bullet
		bullet.position = get_node("shootfrom").global_position

		# Put it two parents above, so it is not moved by us
		get_node("../..").add_child(bullet)

		# Play shooting sound
		get_node("sfx").play("shoot")

	# If we are pressing any movement keys, increase speed
	if motion.x || motion.y:
		speed += acc_boost * ACCELERATION * motion.normalized() * delta

	# If we are NOT pressing any movement keys, and we have some speed, decelerate to a full stop
	elif speed.x || speed.y:
		speed -= acc_boost * ACCELERATION * speed.normalized() * delta

	# Prevents ship speed from going faster than MAX_SPEED
	if speed.length() > MAX_SPEED:
		speed = speed.normalized() * MAX_SPEED

	# Move player
	var pos = position

	# Calculate position to where we are moving
	pos += delta * (speed_boost * speed * motion_factor + root_motion)

	# Prevent ship from going outside the screen
	pos.x = clamp(pos.x, 0, screen_size.x)
	pos.y = clamp(pos.y, 0, screen_size.y)

	# Set new player position
	position = pos

var timer = null
# Start
func _ready():
	# Screen size is used to calculate whether or not the player is inside it
	screen_size = get_viewport_rect().size

	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = shoot_delay_sec

	# Connect area signals
	area_entered.connect(_on_player_area_enter)
	body_entered.connect(_on_player_body_enter)

	# Enable process
	set_process(true)


# SPEED BOOST
# Used by certain pickup items to give the player a speed boost
var speed_timer = null
func speed_boost_activate():
	# If it is not already running
	if speed_boost == 1:
		# If this is the first time running, create timer
		if speed_timer == null:
			speed_timer = Timer.new()
			speed_timer.wait_time = SPEED_BOOST_TIME
			speed_timer.one_shot = true
			add_child(speed_timer)

		# Set speed boost
		speed_boost = SPEED_BOOST_MULTIPLIER

		# Start timer
		speed_timer.start()

		# Wait for timeout
		await speed_timer.timeout

		# Disable speed boost
		speed_boost = 1 # back to 1


# ACCELERATION BOOST
# Used by certain pickup items to give the player more ship control
var acc_timer = null
func acc_boost_activate():
	# If it is not already running
	if acc_boost == 1:
		# If this is the first time running, create timer
		if acc_timer == null:
			acc_timer = Timer.new()
			acc_timer.wait_time = ACC_BOOST_TIME
			acc_timer.one_shot = true
			add_child(acc_timer)

		# Set acceleration boost
		acc_boost = ACC_BOOST_MULTIPLIER

		# Start timer
		acc_timer.start()

		# Wait for timeout
		await acc_timer.timeout

		# Disable acceleration boost
		acc_boost = 1 # back to 1

# On area enter the player
func _on_player_area_enter(area):
	var groups = area.get_groups()

	if groups.has("enemy") or groups.has("enemy_shot"):
		# Play ship 'hit' animation
		anim_player.play("hit")

		# Wait for the animation to complete
		await anim_player.animation_finished

		# Go back to the 'flying' animation (default)
		anim_player.play("flying")

# On body enter the player (for physics-based collisions)
func _on_player_body_enter(body):
	var groups = body.get_groups()

	if groups.has("enemy") or groups.has("enemy_shot"):
		# Play ship 'hit' animation
		anim_player.play("hit")

		# Wait for the animation to complete
		await anim_player.animation_finished

		# Go back to the 'flying' animation (default)
		anim_player.play("flying")
