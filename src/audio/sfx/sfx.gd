extends Node

var sounds = {

	"bronze_bell": preload("res://src/audio/sfx/bronze_bell.ogg"),
	"card_unlock": preload("res://src/audio/sfx/Puzzle_Other_GemMix_Gem_Mix_04.ogg"),
	"chime": preload("res://src/audio/sfx/chime.ogg"),
	"click": preload("res://src/audio/sfx/click.ogg"),
	"cork_pop": preload("res://src/audio/sfx/cork_pop.ogg"),
	"flupp": preload("res://src/audio/sfx/flupp.ogg"),
	"item_pickup": preload("res://src/audio/sfx/Puzzle_Spell_SkillActivation_Skill_Activation_04.ogg"),
	"jump": preload("res://src/audio/sfx/jump.ogg"),
	"land": preload("res://src/audio/sfx/land.ogg"),
	"pin_sound_1": preload("res://src/audio/sfx/pin_sound_1.ogg"),
	"pin_sound_2": preload("res://src/audio/sfx/pin_sound_2.ogg"),
	"pin_sound_3": preload("res://src/audio/sfx/pin_sound_3.ogg"),
	"pin_sound_4": preload("res://src/audio/sfx/pin_sound_4.ogg"),
	"pin_sound_5": preload("res://src/audio/sfx/pin_sound_5.ogg"),
	"pin_sound_6": preload("res://src/audio/sfx/pin_sound_6.ogg"),
	"pin_sound_7": preload("res://src/audio/sfx/pin_sound_7.ogg"),
	"pin_sound_8": preload("res://src/audio/sfx/pin_sound_8.ogg"),
	"punch": preload("res://src/audio/sfx/punch.ogg"),
	"schwuit": preload("res://src/audio/sfx/schwuit.ogg"),
	"shoot": preload("res://src/audio/sfx/shoot.ogg"),
	"step": preload("res://src/audio/sfx/step.ogg"),
	"wood_knock": preload("res://src/audio/sfx/wood_knock.ogg"),
	"yan_secret_pin": preload("res://src/audio/sfx/yan_secret_pin.ogg")
}

func play(sound_name):
	if sounds.has(sound_name):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = sounds[sound_name]
		player.finished.connect(player.queue_free)
		player.play()
	else:
		print("Sound not found: ", sound_name)
