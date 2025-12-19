extends Area2D

@onready var coin = get_node("random_coin")

@export var reward_id: String = ""  # UUID assigned in editor

var destroyed = false
var frame_count = 0

func _ready():
	# Generate UUID if not set
	if reward_id == "" or reward_id.is_empty():
		reward_id = UUID.generate()
		print("=== Generated new UUID: ", reward_id)

	print("=== REWARD READY at: ", position)
	print("=== Reward ID: ", reward_id)
	print("=== Reward Node Name: ", name)
	print("=== Reward Node Path: ", get_path())

	# Check if this reward was already collected
	if Game:
		var collected_rewards = Game.load_key("collected_rewards", [])
		if reward_id in collected_rewards:
			print("=== This reward (", reward_id, ") was already collected, removing it")
			queue_free()
			return
	else:
		print("=== Game singleton not available, keeping reward")

	# Try to find player
	await get_tree().process_frame
	var player = find_player()
	if player:
		print("=== PLAYER FOUND at: ", player.position)

func find_player():
	var player = get_parent().find_child("player")
	if not player:
		player = get_tree().root.find_child("player")
	return player

func _process(delta):
	frame_count += 1

	if frame_count % 30 == 0:
		var overlapping = get_overlapping_bodies()
		print("=== REWARD FRAME ", frame_count, " - Overlapping: ", overlapping.size())

	if destroyed:
		return

	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		print("!!! FOUND OVERLAP !!!")
		for body in overlapping:
			print("=== Body: ", body.name)
			destroy(body)
			return

func destroy(other):
	if destroyed:
		return

	print("!!! DESTROYING REWARD by: ", other.name)
	destroyed = true

	# Add this reward's UUID to the collected rewards list
	var collected_rewards = Game.load_key("collected_rewards", [])
	if reward_id not in collected_rewards:
		collected_rewards.append(reward_id)
		Game.save_key("collected_rewards", collected_rewards)
		Game.save_game()  # Immediately save to disk
		print("=== Saved collected reward: ", reward_id)

	Game.collect_item()
	coin.take()

	await get_tree().create_timer(0.5).timeout
	queue_free()
