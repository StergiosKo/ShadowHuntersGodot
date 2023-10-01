extends Control

class_name DiceManager

var dicePrefab
var grid
var dices
var currentEnum
var canroll
var gamemanager

enum roll_enum {LOCATION, REGULARDAMAGE, GUARENDAMAGE}

signal playerRolledDice(diceresult)

# Called when the node enters the scene tree for the first time.
func _ready():
	dicePrefab = load("res://scenes/prefabs/dice.tscn")
	gamemanager = get_node("../GameManager")
	grid = get_node("DiceGrid")
	canroll = false
	setup_dice(roll_enum.LOCATION)

func setup_dice(forwhat):
	for n in grid.get_children():
		grid.remove_child(n)
		n.queue_free()
	dices = []
	currentEnum = forwhat
	canroll = true
	match forwhat:
		roll_enum.LOCATION:
			gamemanager.update_tooltip_text("Roll dice to move")
			add_dice(6)
			add_dice(4)
		roll_enum.REGULARDAMAGE:
			gamemanager.update_tooltip_text("Dice rolled for damage")
			add_dice(6)
			add_dice(4)
		roll_enum.GUARENDAMAGE:
			add_dice(4)

func roll_dice():
	if (!canroll): return 0
	canroll = false
	var results = []
	var finalresult = 0
	for die in dices:
		results.append(die.roll_dice())
	match currentEnum:
		roll_enum.LOCATION:
			for result in results:
				finalresult += result
		roll_enum.REGULARDAMAGE:
			finalresult = results.max() - results.min()
		roll_enum.GUARENDAMAGE:
			finalresult = results[0]
	return finalresult

func add_dice(maxroll):
	var diceinstance = dicePrefab.instantiate()
	dices.append(diceinstance)
	grid.add_child(diceinstance)
	diceinstance.set_maxdiceroll(maxroll)

func roll_single_dice():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	var result = roll_dice()
	if (result == 0): return
	playerRolledDice.emit(result)
	

