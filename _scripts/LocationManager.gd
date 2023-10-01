extends Control

class_name LocationManager

var locationprefab = load("res://scenes/prefabs/location.tscn")
var locations = []
var locdata = parse_json("res://data/locations.json")
var gamemanager

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance
	gamemanager = get_node("../GameManager")
	var childnodes = self.get_children()
	for i in range(0, self.get_children().size()):
		childnodes[i].setup_location(locdata["locations"][i])
		locations.append(childnodes[i])
	
	for i in range(0, locations.size() - 1):
		locations[i].set_connected_locations([locations[i-1], locations[i+1]])

func get_location(diceroll):
	for loc in locations:
		if (loc.is_in_location(diceroll)):
			return loc

func get_location_players(player):
	return player.get_location().get_other_players(player)

func get_neighbour_players(player):
	return player.get_location().get_neighbour_players(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parse_json(path):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict
