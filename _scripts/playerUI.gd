extends Node

class_name PlayerUI

var colorNode
var labelNode
var moveablePlayerNode
var damageLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	colorNode = get_node("Color")
	labelNode = get_node("Name")
	moveablePlayerNode = get_node("Pawn")
	damageLabel = get_node("DamageTakenBack/DamageLabel")

func updateColor(color):
	colorNode.set_color(color)

func updatePawn(player):
	if(moveablePlayerNode):
		moveablePlayerNode.assign_player(player)

func updateName(text):
	labelNode.text = text

func updateDamage(currentDamage):
	damageLabel.text = str(currentDamage)

func get_pawn():
	return moveablePlayerNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
