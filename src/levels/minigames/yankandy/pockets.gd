
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var pocket_entered = false

func _ready():
#	get_node("../hud/score_text").set_text(str(score))
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_pocket1_body_entered( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		Global.yankandy_score_total += 200
		pocket_entered = true
		pass # replace with function body

func _on_pocket2_body_entered( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		Global.yankandy_score_total += 300
		pocket_entered = true
		pass # replace with function body


func _on_pocket3_body_entered( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		Global.yankandy_score_total += 600
		pocket_entered = true
		pass # replace with function body

func _on_pocket4_body_entered( body ):
	if body.get_name() == "ball" && pocket_entered == false:
		Global.yankandy_score_total *= 5
		get_node("../../sfx").play("bronze_bell")
		pocket_entered = true
		pass # replace with function body
