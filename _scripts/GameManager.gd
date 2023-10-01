extends Node

class_name GameManager

var players = [];
var jsonCharacterData = "res://data/characterData.json"
var playerIconPrefab = "res://scenes/prefabs/player_icon.tscn"
var characterClass = load("res://_scripts/Character.gd")
var playersContainer
var tooltip

var cardmanager

signal gameready

var colorArray = PackedColorArray([Color(0.1, 0.2, 0.3), Color(0.4, 0.5, 0.6),
 Color(0.2, 0.3, 0.3), Color(0.8, 0.7, 0.7)])


# Called when the node enters the scene tree for the first time.
func _ready():
	cardmanager = get_node("../CardManager")
	playersContainer = get_node("../PlayersContainer")
	var jsonData = parse_json(jsonCharacterData)
	var new_node = load(playerIconPrefab)
	tooltip = get_node("../Tooltip")
	var instance
	for i in jsonData['card'].size():
		instance = new_node.instantiate()
		instance.id = i
		instance.color = colorArray[i]
		instance.character = characterClass.new(jsonData['card'][i])
		players.append(instance)
		playersContainer.add_child(instance)
	await get_tree().create_timer(0.3).timeout
	gameready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parse_json(path):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict

func player_draw_card(player, color):
	cardmanager.draw_card(player, color)

func check_player_goals():
	for player in players:
		print(str(player.id) + "' goal is " + str(player.character.goal_complete(self)))

func update_tooltip_text(text):
	tooltip.set_text(text)

func _on_button_pressed():
	#check_player_goals()
	pass
