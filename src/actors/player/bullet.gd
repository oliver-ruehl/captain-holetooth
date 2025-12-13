extends RigidBody2D

var disabled = false

func disable():
	if (disabled):
		return
	get_node("anim").play("shutdown")
	disabled = true

func _ready():
	get_node("Timer").start()
