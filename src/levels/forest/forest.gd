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
	# Get enemy group
	Game.open_scene("scn3")

func run_debug():
	pass
