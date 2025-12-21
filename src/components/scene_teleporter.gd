extends Area2D

@export_file("*.tscn") var scene_path

func _ready():
	var label = find_child("teleporter_debug_label", true, false)
	if label:
		label.text = str(scene_path)

func _on_scene_teleporter_body_entered( body ):

	if Global.player_inventory.has("Ship Wing"):
		pass
	else:
		pass
	body.set_process(false)
	#find_child("teleporter_debug_label").text = scene_path
	if body.name == "player":
		var current_scene_name = str(get_tree().current_scene.name)
		var idx = -1
		var last_char = current_scene_name.right(1)

		if last_char.is_valid_int():
			idx = last_char.to_int() - 3

		if idx >= 0 and idx < Global.last_pos.size():
			Global.last_pos[idx] = body.global_position

		Transition.fade_to(str(scene_path))
