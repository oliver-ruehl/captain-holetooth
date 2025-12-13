extends CharacterBody2D

# Gameplay Variables
var speed = 220  # Speed this will move
var distanceBetween = 100    # Distance between this and the player before we start moving towards

# References
var playerNode; # Player node
var plrLastPos; # Players current position (Saved for next frame)

func _ready():
	playerNode = get_node("/root/scn3/player")
	plrLastPos = playerNode.global_position # Make this not null for first frame
	set_physics_process(true)

func _physics_process(delta):
	var plrPos = playerNode.global_position
	print(plrPos)
	var distancePlayerMoved = plrLastPos.distance_to(plrPos) # The distance between player this and last frame

	if(position.distance_to(plrPos) > distanceBetween):  # Only move if the distance between is larger than max
		var dir = (plrLastPos - plrPos).normalized()      # Get direction player moved
		var pointToMoveTo = ((plrPos + dir * distanceBetween) - global_position) # Get the point that is behind where the player is moving "distanceBetween" pixels away
		velocity = pointToMoveTo.normalized() * speed
		move_and_slide()

	plrLastPos = plrPos # Record player position this frame for next
