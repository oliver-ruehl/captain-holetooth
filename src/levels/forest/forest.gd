extends Node2D

# -- START --
func _ready():
	# Get initial player spawn position
	var initial_pos_player = get_node("world/initial_spawn_player").global_position

	# Set player position
	if Global.last_pos[0] != Vector2(0,0):
		Global.last_pos[0].x -= 100
		initial_pos_player = Global.last_pos[0]

	get_node("player").global_position = initial_pos_player

	# Set up camera to follow player for parallax effect
	var camera = Camera2D.new()
	camera.global_position = get_node("player").global_position
	camera.make_current()
	add_child(camera)

	# Get enemy group
	Game.open_scene("scn3")

func _process(delta):
	# Make camera follow player
	var camera = get_viewport().get_camera_2d()
	if camera:
		var player = get_node("player")
		camera.global_position = player.global_position

func run_debug():
	pass
