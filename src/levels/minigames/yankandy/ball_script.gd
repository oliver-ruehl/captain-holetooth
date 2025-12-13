
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var released = false
var speed = 3
var ballpos = Vector2(0, 0)
var last_collision_time = 0.0
var collision_cooldown = 0.3  # Prevent sound spam, increased for better sound quality

func _physics_process(delta):

	randomize()
	var random_friction = randf()*0.3+0.05
	var random_bounce = randf()*0.8+0.09

	if physics_material_override == null:
		physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = random_friction
	physics_material_override.bounce = random_bounce

	# Play collision sound when ball hits something
	if released and get_colliding_bodies().size() > 0:
		if Time.get_ticks_msec() - last_collision_time > collision_cooldown * 1000:
			get_node("../sfx").play("wood_knock")
			last_collision_time = Time.get_ticks_msec()

	var direction = Vector2(0,0)

	if released == false:

		if Input.is_action_pressed("ui_left"):
			print("ui_left")
			direction += speed * Vector2(-1,0)

		if Input.is_action_pressed("ui_right"):
			print("ui_right")
			direction += speed * Vector2(1,0)

	if Input.is_action_just_pressed("ui_down"): print("DEBUG: ui_down")
	if Input.is_action_just_pressed("ui_select"): print("DEBUG: ui_select")
	if Input.is_action_just_pressed("ui_accept"): print("DEBUG: ui_accept")

	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE)) and released == false:
			print("Release!")
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
