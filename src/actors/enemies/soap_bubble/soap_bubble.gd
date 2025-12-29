extends "res://src/actors/common/flying_npc.gd"

@onready var REWARD = preload("res://src/objects/rewards/reward.tscn")
@onready var animation = get_node("anim_player")
# PLAYER
# On Collision with another Body
