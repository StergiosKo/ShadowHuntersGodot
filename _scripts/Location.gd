extends Node

class_name Location

var locationUI
var locname
var description
var diceneeded
var effect
var playershere
var connectedLocations = []


# Called when the node enters the scene tree for the first time.
func _ready():
	locationUI = get_node("LocationUI")
	playershere = []

func setup_location(data):
	if (!locationUI):
		locationUI = get_node("LocationUI")
	locname = data["name"]
	description = data["description"]
	diceneeded = data["dice_rolls"]
	effect = data["effects"]
	locationUI.setup_location(locname, description, diceneeded)

func set_connected_locations(locations):
	connectedLocations.append_array(locations)

func is_in_location(diceroll):
	for dice in diceneeded:
		if(dice == diceroll): return true
	return false

func add_player(player):
	locationUI.add_player(player.get_pawn())
	playershere.append(player)
	player.get_pawn().set_location(self)

func remove_player(player):
	playershere.erase(player)

func activate_effect(player):
	pass

func get_players():
	return playershere

func get_neighbour_players(player):
	var tmpPlayers = []
	for loc in connectedLocations:
		tmpPlayers.append_array(loc.get_other_players(player))
	return tmpPlayers

func get_other_players(player):
	var tmpPlayers = []
	for tmpplayer in playershere:
		if (player.id != tmpplayer.id):
			tmpPlayers.append(tmpplayer)
	return tmpPlayers

func is_player_in_location(pawn):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
