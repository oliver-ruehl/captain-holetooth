extends Area2D

@onready var coin = get_node("random_coin")

var destroyed = false


func destroy():
	if destroyed:
		return

	destroyed = true
	coin.play_taken_animation()
	Game.collect_item()
	await get_tree().create_timer(0.5).timeout
	queue_free()
