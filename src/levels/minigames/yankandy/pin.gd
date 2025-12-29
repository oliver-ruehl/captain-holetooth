
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var secret_pin_hit = false

@export_enum("box_area1", "box_area2", "box_area3", "box_area4", "box_area5", "box_area6", "box_area7", "box_area8", "box_secret_pin") var box_area: String

# Sound mapping for each box area
const SOUND_MAP = {
	"box_area1": "pin_sound_1",
	"box_area2": "pin_sound_2",
	"box_area3": "pin_sound_3",
	"box_area4": "pin_sound_4",
	"box_area5": "pin_sound_5",
	"box_area6": "pin_sound_6",
	"box_area7": "pin_sound_7",
	"box_area8": "pin_sound_8"
}

func _ready():
	pass

func anim_popup_score():
	get_node("pin_score_flag/pin_score_text").text = str(Global.yankandy_score_pins)

func _on_pin_body_entered( body ):
	var touchbody = body.get_name()
	#if body.get_name() == "ball":
	print(touchbody + " touched pin")
	Global.yankandy_score_pins += 1
	Global.yankandy_score_multiplier += 1
	Global.yankandy_score_total += Global.yankandy_score_pins * Global.yankandy_score_multiplier
	get_node("score_animation").play("pin_score_anim")

	# Play sound based on box area using dictionary lookup
	if box_area in SOUND_MAP:
		get_node("sfx").play(SOUND_MAP[box_area])
	elif box_area == "box_secret_pin" and secret_pin_hit == false:
		secret_pin_hit = true
		Global.yankandy_score_total += 5000
		get_node("sfx").play("yan_secret_pin")
		get_node("sfx").play("bronze_bell")
		get_node("score_animation").play("secret_pin_animation")

	else:
		# Old code that randomized the pins, just here for future use maybe
		#randomize()
		#var pinsound_random = randi()%8+1
		#print(pinsound_random)
		#get_node("sfx").play("pin_sound_" + str(pinsound_random))
		get_node("sfx").play("tin")
