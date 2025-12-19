extends Node

class_name UUID

# Generate a UUID v4
static func generate() -> String:
	randomize()
	var uuid = ""
	var hex_chars = "0123456789abcdef"

	# Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
	for i in range(36):
		if i == 8 or i == 13 or i == 18 or i == 23:
			uuid += "-"
		elif i == 14:
			uuid += "4"
		elif i == 19:
			uuid += hex_chars[randi() % 4 + 8]  # y: 8, 9, a, or b
		else:
			uuid += hex_chars[randi() % 16]

	return uuid

# Validate UUID format
static func is_valid(uuid: String) -> bool:
	var pattern = "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
	var regex = RegEx.new()
	regex.compile(pattern)
	return regex.search(uuid) != null
