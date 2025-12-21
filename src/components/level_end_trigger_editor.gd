@tool
extends EditorScript

# This script helps visualize the available levels as a dropdown in the inspector
# Gdscript doesn't have built-in enum generation, so we use this workaround

func _run():
	var trigger = get_scene()
	if trigger and trigger.has_method("_discover_levels"):
		trigger._discover_levels()
