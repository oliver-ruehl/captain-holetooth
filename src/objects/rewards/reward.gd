extends Area2D

@onready var coin = get_node("random_coin")

@export var reward_id: String = ""  # UUID assigned in editor

var destroyed = false
var frame_count = 0

func _ready():
	# Generate UUID if not set
	if reward_id == "" or reward_id.is_empty():
		reward_id = str(get_path())

	# Check if this reward was already collected
	if Game:
		var collected_rewards = Game.load_key("collected_rewards", [])
		if reward_id in collected_rewards:
			queue_free()
			return

	# Try to find player
	await get_tree().process_frame
	var player = find_player()

func find_player():
	var player = get_parent().find_child("player")
	if not player:
		player = get_tree().root.find_child("player")
	return player

func _process(delta):
	if destroyed:
		return

	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for body in overlapping:
			destroy(body)
			return

func destroy(other):
	if destroyed:
		return

	destroyed = true

	# Add this reward's UUID to the collected rewards list
	var collected_rewards = Game.load_key("collected_rewards", [])
	if reward_id not in collected_rewards:
		collected_rewards.append(reward_id)
		Game.save_key("collected_rewards", collected_rewards)
		Game.save_game()  # Immediately save to disk

	Game.collect_item()
	coin.take()

	await get_tree().create_timer(0.5).timeout
	queue_free()
