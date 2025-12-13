extends AudioStreamPlayer

func _ready():
	# Set volume to match global every time this is instanced
	if Global.music:
		volume_db = linear_to_db(Global.music.volume)
	# Ensure audio bus is unmuted
	bus = &"Master"
	# Start playing music
	play()


func set_volume(vol):
	volume_db = linear_to_db(vol)
