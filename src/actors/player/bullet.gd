extends RigidBody2D

var disabled = false
const BULLET_SPEED = 400  # Speed of the bullet moving forward
const BOUNCE_DAMPENING = 0.88  # How much speed is retained after bounce (0-1)
const MAX_BOUNCES = 6
var bounce_count = 0
var fade_tween: Tween = null

func disable():
	if (disabled):
		return
	get_node("anim").play("shutdown")
	disabled = true

func _ready():
	# Set bullet velocity to move forward (to the right)
	linear_velocity = Vector2(BULLET_SPEED, 0)
	get_node("Timer").start()

	# Connect collision signals for bouncing
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Don't bounce off the player
	if body.is_in_group("player"):
		return

	# Check if it's a tilemap (static body from physics layer)
	if body is TileMap:
		_bounce_off_surface(body)
	# Check for any other physics-based collision
	elif body is StaticBody2D:
		_bounce_off_surface(body)

func _bounce_off_surface(body):
	if bounce_count >= MAX_BOUNCES:
		soft_fade()
		return

	bounce_count += 1

	# Get the contact normal from the collision
	# Since we don't have direct contact info, we'll reflect based on velocity
	var vel = linear_velocity

	# Try to get collision normal if possible
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CollisionShape2D.new()
	query.transform = global_transform

	# Reflect velocity - we need to determine which surface was hit
	# For simplicity, we'll check the closest point on the body to determine bounce direction
	var closest_point = body.get_closest_point_to(global_position)
	var collision_normal = (global_position - closest_point).normalized()

	# Reflect the velocity
	var reflected_velocity = vel.reflect(collision_normal)

	# Apply dampening
	var bounce_velocity = reflected_velocity * BOUNCE_DAMPENING

	# Ensure minimum bounce velocity to prevent falling flat
	var bounce_speed = bounce_velocity.length()
	if bounce_speed < BULLET_SPEED * 0.3:
		bounce_velocity = collision_normal * BULLET_SPEED * 0.4

	linear_velocity = bounce_velocity

	# Fade the bullet slightly with each bounce
	start_fade()

func soft_fade():
	if disabled:
		return
	disabled = true

	# Kill any existing tween
	if fade_tween:
		fade_tween.kill()

	# Fade out modulate (alpha) over 0.5 seconds
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await fade_tween.finished
	queue_free()

func start_fade():
	# Kill any existing tween to prevent conflicts
	if fade_tween:
		fade_tween.kill()

	# Very subtle fade - only reduce by small amount per bounce
	var target_alpha = 1.0 - (bounce_count * 0.08)
	target_alpha = max(target_alpha, 0.3)  # Never fade below 30% opacity
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", target_alpha, 0.3)
