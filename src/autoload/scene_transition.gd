extends Node

# Fade transition settings (can be customized)
var fade_duration_in: float = 0.4
var fade_duration_out: float = 0.8

# Transition state
var is_transitioning: bool = false

func fade_to(scene_path: String) -> void:
	"""Fade to black, change scene, then fade back in"""
	# Prevent multiple transitions at once
	if is_transitioning:
		return

	is_transitioning = true

	# Fade to black
	var fade_overlay = _create_fade_overlay()
	await _fade_in(fade_overlay, fade_duration_in)

	# Change scene
	get_tree().change_scene_to_file(scene_path)

	# Fade from black
	await _fade_out(fade_overlay, fade_duration_out)

	fade_overlay.queue_free()
	is_transitioning = false

func change_scene_instant(scene_path: String) -> void:
	"""Change scene without fade effect"""
	if is_transitioning:
		return

	get_tree().change_scene_to_file(scene_path)

func _create_fade_overlay() -> CanvasLayer:
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # Ensure it's on top
	get_tree().root.add_child(canvas)

	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.anchor_left = 0.0
	rect.anchor_top = 0.0
	rect.anchor_right = 1.0
	rect.anchor_bottom = 1.0
	canvas.add_child(rect)

	return canvas

func _fade_in(overlay: CanvasLayer, duration: float) -> void:
	var rect = overlay.get_child(0) as ColorRect
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(rect, "modulate", Color.BLACK, duration)
	await tween.finished

func _fade_out(overlay: CanvasLayer, duration: float) -> void:
	var rect = overlay.get_child(0) as ColorRect
	rect.modulate = Color.BLACK
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(rect, "modulate", Color.WHITE, duration)
	await tween.finished
