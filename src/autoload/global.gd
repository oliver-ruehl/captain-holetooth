extends Node

###########
# GLOBALS #
###########

# Audio Data
@export var debug_mode = 1 # 1 for debug and 0 for release mode

static var music = {
	"volume": 1.0, # <0, 1>
	"enabled": true,
}

#####################
# Parental Controls #
#####################

var time_elapsed = 0

var playtime_limit_minutes = 15
var playtime_limit_seconds = playtime_limit_minutes * 60

##################
# Fun Statistics #
##################

var times_jumped = 0
var bubbles_popped = 0

###################
# HUD and scoring #
###################

const MAX_ITEMS = 120
var score = 0
var final_score = 0
var high_score = 0
var items_collected = 0

# Scoring Minigame yankandy
var yankandy_score_pins = 0
var yankandy_score_pocket = 0
var yankandy_score_multiplier = 1
var yankandy_score_total = 0

# Scene related
var currentScene = null

# Check if player has visited a scene already and store the last position on leaving/spawning
var last_pos = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]

# Array for characters the player has met
var characters_met = ["Captain Holetooth"]

##################
# Items          #
##################

var kills = false
const SCORE_MULTIPLIER = 10
const SCORE_MULTIPLIER_KILLS = 5

##################
# Inventory      #
##################

var player_inventory = []

func manage_inv(inv_action, inv_item):
	if inv_action == "pickup":
		player_inventory.append(inv_item)

	elif inv_action == "drop":
		player_inventory.erase(inv_item)

##################
# Database       #
##################

func _ready():
	# Assuming Database singleton is named Database
	score = Database.get_key("score", 0)

func add_score(value=1):
	score += value
	Database.set_key("score", score)
