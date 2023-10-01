extends Node

class_name CardManager

var cardClass = load("res://_scripts/DrawableCard.gd")
var jsonCardData = "res://data/drawableCards.json"

var redCards
var blueCards
var greenCards
var discardPile

# Called when the node enters the scene tree for the first time.
func _ready():

	ready_game()

func ready_game():
	redCards = []
	blueCards = []
	greenCards = []
	discardPile = []
	var tempPile
	var jsonData = parse_json(jsonCardData)
	for card in jsonData['card']:
		tempPile = get_color_pile(card['color'])
		for i in card['amount']:
			tempPile.append(cardClass.new(card))
	redCards.shuffle()
	blueCards.shuffle()
	greenCards.shuffle()

func get_color_pile(color):
	if color == "red": return redCards
	elif color == "blue": return blueCards
	else: return greenCards

func draw_card(player, color):
	var tmpPile = get_color_pile(color)
	var topCard = tmpPile.pop_back()
	player.draw_card(topCard)

func parse_json(path):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict
