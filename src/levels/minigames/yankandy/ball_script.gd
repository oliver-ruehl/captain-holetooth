
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var released = false
var speed = 3
var ballpos = Vector2(0, 0)
var last_collision_time = 0.0
var collision_cooldown = 0.3  # Prevent sound spam, increased for better sound quality
var velocity_threshold = 5.0  # Minimum velocity to trigger sound
var rest_threshold = 0.5  # Velocity below this is considered at rest
var time_at_rest = 0.0
var rest_timeout = 2.0  # Stop physics after 2 seconds at rest

func _physics_process(_delta):

	randomize()
	var random_friction = randf()*0.3+0.05
	var random_bounce = randf()*0.8+0.09

	if physics_material_override == null:
		physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = random_friction
	physics_material_override.bounce = random_bounce

	# Check if ball is at rest and stop physics
	if released:
		var current_velocity = linear_velocity.length()

		# Track if ball is moving slowly (at rest)
		if current_velocity < rest_threshold:
			time_at_rest += _delta
			if time_at_rest > rest_timeout:
				freeze = true  # Stop all physics
				set_physics_process(false)  # Stop calling this function
		else:
			time_at_rest = 0.0

		# Play collision sound only on impactful collisions
		if get_colliding_bodies().size() > 0:
			if Time.get_ticks_msec() - last_collision_time > collision_cooldown * 1000:
				# Only play sound if ball is moving fast enough
				if current_velocity > velocity_threshold:
					get_node("../sfx").play("wood_knock")
					last_collision_time = Time.get_ticks_msec()

	var direction = Vector2(0,0)

	if released == false:

		if Input.is_action_pressed("ui_left"):
			direction += speed * Vector2(-1,0)

		if Input.is_action_pressed("ui_right"):
			direction += speed * Vector2(1,0)

	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE)) and released == false:
			released = true
			mass = 95
			gravity_scale = 0.8
			freeze = false
			apply_central_impulse(Vector2(0, 10))

	# Keep camera focused on ball, only vertical scrolling
	var camera = get_node("Camera2D")
	camera.global_position.y = global_position.y
	camera.global_position.x = 550  # Keep horizontal position centered

	if not released:
		ballpos = position + direction
		self.position = ballpos
func _ready():
	set_physics_process(true)
	mass = 1
	gravity_scale = 0
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	contact_monitor = true
	max_contacts_reported = 10
