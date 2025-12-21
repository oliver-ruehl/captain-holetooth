
extends AnimatedSprite2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)

func _process(delta):
	get_parent().offset += Vector2(120*delta, 0)

func gotonext():
	SceneTransition.fade_to("res://src/screens/cutscenes/cutscene_ship_repair/cutscene_ship_repair.tscn")
