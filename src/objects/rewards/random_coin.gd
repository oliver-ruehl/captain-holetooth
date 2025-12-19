signal taken

@onready var anim = get_node("anim")
@onready var sfx = get_node("sfx")

func _ready():
	pass


func play_taken_animation():
	anim.play("taken")
	sfx.play()
