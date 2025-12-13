extends Area2D

@export_file("*.tscn") var scene_path

func _ready():
	print (str(scene_path) + ", " + str(get_path()))
	var label = find_child("teleporter_debug_label", true, false)
	if label:
		label.text = str(scene_path)

func _on_scene_teleporter_body_entered( body ):
	print("Teleporting to " + str(scene_path))

	if Global.player_inventory.has("Ship Wing"):
		print("You have the wing")
	else:
		print("Sorry, no wing")
	body.set_process(false)
	#find_child("teleporter_debug_label").text = scene_path
	if body.name == "player":
		var current = str(get_tree().current_scene.name)
		Global.last_pos[current[current.length()-1].to_int() - 3] = body.global_position
		Transition.fade_to(str(scene_path))
