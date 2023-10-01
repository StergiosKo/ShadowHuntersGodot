extends Control

class_name LocationUI

var colorrect
var namelabel
var desclabel
var playersgrid
var dicelabel


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_nodes()

func setup_location(locname, locdesc, locdice):
	setup_nodes()
	namelabel.text = locname
	desclabel.text = locdesc
	var dicetext = ""
	for dice in locdice:
		dicetext += str(dice) + " "
	dicelabel.text = dicetext
	

func setup_nodes():
	colorrect = get_node("ColorRect")
	namelabel = get_node("Name")
	desclabel = get_node("Description")
	playersgrid = get_node("PlayersContainer")
	dicelabel = get_node("DiceNeeded/DiceLabel")

func add_player(node):
	node.reparent(playersgrid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
