class_name Character

var charactername
var faction
var maxhealth
var description
var abilities
var goal

func _init(data):
	charactername = data["name"]
	faction = data["faction"]
	maxhealth = data["health"]
	description = data["description"]
	abilities = data["abilities"]
	goal = data["goal"]


func goal_complete(gamestate):
	if(goal["type"] == "defeat"):
		for player in gamestate.players:
			if (player.character.faction == goal["parameter"]):
				if !player.is_dead():
					return false
		return true
