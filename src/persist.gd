extends Node

func _enter_tree():
	var key = str(get_parent().get_path())
	var state = Game.load_key(key)
	if state != null and state.get("destroyed", false):
		# get_parent().queue_free()
		return
	
func _exit_tree():
	var key = str(get_parent().get_path())
	if get_parent().get("destroyed"):
		Game.save_key(key, {"destroyed":true})
