extends CanvasLayer

# Animation player for fading
@onready var anim = $AnimationPlayer

# Fade controller
var fading = false

# Fade to scene path
func fade_to(path):
	# If we are currently fading to a scene, return
	if fading:
		return

	# Set fading to true to prevent fading while fading
	fading = true

	# Start fading in and out
	if anim != null:
		anim.play("fade_in")
	else:
		return

	# Wait until animation is finished
	await anim.animation_finished

	# Chance scene
	get_tree().change_scene_to_file(path)

	# Fade back out into the new scene
	anim.play("fade_out")

	# No longer fading, so we are ready to fade again when needed
	fading = false
