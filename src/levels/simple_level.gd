extends Node2D

func _ready():
	var tilemap = $world/tile_map
	# Clear existing tiles just in case
	tilemap.clear()

	# Generate a floor
	for x in range(0, 100):
		# Set tiles at y=10 (approx bottom of screen if camera is at 0,0)
		# Using Source ID 0 (likely the only source) and atlas coord (0, 1) for "solid" tile
		tilemap.set_cell(0, Vector2i(x, 10), 0, Vector2i(0, 1))

		# Add some walls
		if x == 0 or x == 99:
			for y in range(0, 10):
				tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 1))

	# Fallback static floor in case TileMap isn't set up correctly
	var floor_body = StaticBody2D.new()
	floor_body.position = Vector2(0, 640) # Below the tilemap floor (10 * 64 = 640)
	add_child(floor_body)

	var col = CollisionPolygon2D.new()
	col.polygon = PackedVector2Array([-1000, 0, 8000, 0, 8000, 100, -1000, 100])
	floor_body.add_child(col)

	var poly = Polygon2D.new()
	poly.polygon = col.polygon
	poly.color = Color(0.3, 0.3, 0.3)
	floor_body.add_child(poly)
