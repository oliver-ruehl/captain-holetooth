extends Area2D

# Path to the next level scene file
@export_file("*.tscn") var next_level_scene: String

# Whether to use fade transition when changing scenes
@export var use_fade_transition: bool = true

func _ready():
	# Connect the body_entered signal ensuring it triggers when something enters the area
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# Check if the entering body is the player
	if body.is_in_group("player"):
		call_deferred("_transition_to_next_level")

func _transition_to_next_level():
	if next_level_scene and not next_level_scene.is_empty():
		if use_fade_transition:
			await SceneTransition.fade_to(next_level_scene)
		else:
			SceneTransition.change_scene_instant(next_level_scene)
	else:
		push_warning("Level End Reached, but 'next_level_scene' is not set in " + str(get_path()))
