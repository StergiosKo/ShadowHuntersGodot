extends Node

class_name TurnManager

var playersIds = []
var turnIndex = 0 # Which player's turn it is
var turnCounter = 0 # How many turns have passed
var gamemanager

signal playerTurnStarted(playerId)


# Called when the node enters the scene tree for the first time.
func _ready():
	gamemanager = get_node("../GameManager")
	gamemanager.gameready.connect(next_turn)

func game_start(players):
	for player in players:
		playersIds.append(player.id)
	turnIndex = 0
	playerTurnStarted.emit(playersIds[turnIndex])

func add_player(id):
	playersIds.append(id)

func next_turn():
	if (turnIndex > playersIds.size() - 1):
		turnIndex = 0
		turnCounter += 1
	playerTurnStarted.emit(playersIds[turnIndex])
	turnIndex += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	next_turn()
