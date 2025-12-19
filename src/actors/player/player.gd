extends RigidBody2D

# Member variables
var anim = ""
var siding_left = false
var jumping = false
var shooting = false

var WALK_ACCEL = 2000.0
var WALK_DEACCEL = 2000.0
var WALK_MAX_VELOCITY = 300.0
var AIR_ACCEL = 300.0
var AIR_DEACCEL = 2900.0
var JUMP_VELOCITY = 438
var STOP_JUMP_FORCE = 2000.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var DIR_LEFT = Vector2(-1,1)
var DIR_RIGHT = Vector2(1,1)
var CURR_DIR = Vector2(1,1)
var LAST_DIR = Vector2(0,0)

var airborne_time = 1e20
var shoot_time = 1e20

var MAX_SHOOT_POSE_TIME = 0.3

var bullet = preload("res://src/actors/player/bullet.tscn")

var floor_h_velocity = 0.0
# var enemy # Missing resource

func _integrate_forces(state):
	var linear_vel = state.linear_velocity
	var step = state.step

	var new_anim = anim

	# Get the controls
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_select")
	var shoot = Input.is_action_pressed("ui_accept")

	# Deapply prev floor velocity
	linear_vel.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor
	var found_floor = false
	var floor_index = -1

	for x in range(state.get_contact_count()):
		var ci = state.get_contact_local_normal(x)
		if (ci.dot(Vector2(0, -1)) > 0.6):
			found_floor = true
			floor_index = x

	if (found_floor):
		airborne_time = 0.0
	else:
		airborne_time += step

	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	if (jumping):
		if (linear_vel.y > 0):
			jumping = false
		if (!jump):
			linear_vel.y += STOP_JUMP_FORCE * step

	if (on_floor):
		if (move_left and not move_right):
			CURR_DIR = DIR_LEFT
			if (linear_vel.x > -WALK_MAX_VELOCITY):
				linear_vel.x -= WALK_ACCEL * step
				if(linear_vel.x < -WALK_MAX_VELOCITY):
					linear_vel.x = -WALK_MAX_VELOCITY

		elif (move_right and not move_left):
			CURR_DIR = DIR_RIGHT
			if (linear_vel.x < WALK_MAX_VELOCITY):
				linear_vel.x += WALK_ACCEL * step
				if(linear_vel.x > WALK_MAX_VELOCITY):
					linear_vel.x = WALK_MAX_VELOCITY
		else:
			var xv = abs(linear_vel.x)
			xv -= WALK_DEACCEL * step
			if (xv < 0):
				xv = 0
			linear_vel.x = sign(linear_vel.x) * xv

		if (!jumping && jump):
			linear_vel.y = -JUMP_VELOCITY
			jumping = true

			# if !get_node("sfx").is_active():
			# get_node("sfx").play("jump")

			if Global.times_jumped:
				Global.times_jumped = Global.times_jumped + 1

			if (Global.times_jumped and Global.times_jumped > 50):
				JUMP_VELOCITY = 550
				#print("Yay! You can now jump higher")
				#TODO: Print an achievement notification message to the player

		if (jumping):
			new_anim = "jumping"
		elif (abs(linear_vel.x) < 0.1):
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "idle_weapon"
			else:
				new_anim = "idle"
		else:
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "run_weapon"
			else:
				new_anim = "run"
	else:
		if (move_left && !move_right):
			CURR_DIR = DIR_LEFT
			if (linear_vel.x > -WALK_MAX_VELOCITY):
				linear_vel.x -= AIR_ACCEL * step
				if(linear_vel.x < -WALK_MAX_VELOCITY):
					linear_vel.x = -WALK_MAX_VELOCITY

		elif (move_right && !move_left):
			CURR_DIR = DIR_RIGHT
			if (linear_vel.x < WALK_MAX_VELOCITY):
				linear_vel.x += AIR_ACCEL * step
				if(linear_vel.x > WALK_MAX_VELOCITY):
					linear_vel.x = WALK_MAX_VELOCITY
		else:
			var x_vel = abs(linear_vel.x)
			x_vel -= AIR_DEACCEL * step
			if (x_vel < 0):
				x_vel = 0
			linear_vel.x = sign(linear_vel.x) * x_vel

		if (linear_vel.y < 0):
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "falling_weapon"
			else:
				new_anim = "falling"

	if (shoot and not shooting):
		shoot_time = 0
		call_deferred("_spawn_bullet")
	else:
		shoot_time += step

	if (LAST_DIR != CURR_DIR):
		if (move_left):
			get_node("sprite").scale = DIR_LEFT
			LAST_DIR = DIR_LEFT
		elif(move_right):
			get_node("sprite").scale = DIR_RIGHT
			LAST_DIR = DIR_RIGHT

	if (new_anim != anim):
		anim = new_anim
		get_node("anim").play(anim)

	shooting = shoot

	if (found_floor):
		floor_h_velocity = state.get_contact_collider_velocity_at_position(floor_index).x
		linear_vel.x += floor_h_velocity

	linear_vel += state.total_gravity * step
	state.linear_velocity = linear_vel

func _spawn_bullet():
	var bi = bullet.instantiate()
	var pos = position + get_node("bullet_shoot").position * CURR_DIR

	bi.position = pos
	get_parent().add_child(bi)

	bi.linear_velocity = Vector2(800.0 * CURR_DIR.x, -80)
	get_node("sprite/smoke").emitting = true
	# get_node("sfx").play("schwuit")
	PhysicsServer2D.body_add_collision_exception(bi.get_rid(), get_rid())

func _ready():
	set_process(true)
	# enemy = load("res://scenes/scn3-forest/enemy.tscn")

func _process(delta):
	if Global and Global.time_elapsed:
		Global.time_elapsed += delta
		if Global and Global.playtime_limit_seconds and Global.time_elapsed >= int(Global.playtime_limit_seconds):
			Global.time_elapsed = 0
