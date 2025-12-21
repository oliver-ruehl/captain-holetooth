extends Area2D

# Transition type: "local" (same scene) or "scene" (change scene)
@export var transition_type: String = "local"

# For local transitions: destination position within the same scene
@export var destination_position: Vector2 = Vector2.ZERO

# For scene transitions: path to the destination scene
@export_file("*.tscn") var destination_scene: String = ""

# For scene transitions: where to spawn the player in the new scene
@export var spawn_position: Vector2 = Vector2.ZERO

# Optional label for debugging/organization
@export var room_name: String = "Room"

func _ready():
	# Connect the body_entered signal
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# Check if the entering body is the player
	if body.is_in_group("player"):
		call_deferred("_transition")

func _transition():
	if transition_type == "local":
		await SceneTransition.fade_to_position(destination_position)
	elif transition_type == "scene":
		if destination_scene:
			# Store spawn position in global state for the new scene to use
			Global.player_spawn_position = spawn_position if spawn_position != Vector2.ZERO else destination_position
			await SceneTransition.fade_to(destination_scene)
		else:
			push_warning("Door transition type is 'scene' but no destination_scene is set in " + str(get_path()))
