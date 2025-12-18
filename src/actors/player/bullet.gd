extends RigidBody2D

var disabled = false
const BULLET_SPEED = 400  # Speed of the bullet moving forward

func disable():
	if (disabled):
		return
	get_node("anim").play("shutdown")
	disabled = true

func _ready():
	# Set bullet velocity to move forward (to the right)
	linear_velocity = Vector2(BULLET_SPEED, 0)
	get_node("Timer").start()
