extends Control

var i = 0
var number_of_cards = Global.characters_met.size()
var character_cards = preload("res://src/objects/character_cards/character_card.tscn")

func _ready():
	var card_space = self.size
	var card_container_position = self.get_index()
	var left_margin = 100
	var top_margin = 140
	var innercard_margin_w = 10
	var innercard_margin_h = 10
	#print(character_cards_size)
	#character_cards_instance.set_global_pos(cc_default_pos)

	var max_w = 0.0
	var max_h = 0.0

	while i < number_of_cards:
		#var x = left_margin + ((i % 3) * (innercard_margin_w + card_width)) and y = top_margin + (floor(i / 3) * (innercard_margin_h + card_height))
		var character_cards_instance = character_cards.instantiate()
		var character_card_name = Global.characters_met[i]
		add_child(character_cards_instance)
		var card_dimensions = character_cards_instance.get_node("character_card_button").size
		var card_height = card_dimensions.y
		var card_width = card_dimensions.x
		character_cards_instance.position = Vector2(left_margin + ((i % 3) * (innercard_margin_w + card_width)), top_margin + (floor(i / 3) * (innercard_margin_h + card_height)))
		i += 1
		character_cards_instance.get_node("character_card_debug_label").text = character_card_name

		if character_cards_instance.position.x + card_width > max_w:
			max_w = character_cards_instance.position.x + card_width
		if character_cards_instance.position.y + card_height > max_h:
			max_h = character_cards_instance.position.y + card_height

	custom_minimum_size = Vector2(max_w + left_margin, max_h + top_margin)
