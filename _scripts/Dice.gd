extends Control

class_name Dice

var label
var maxdiceroll

func roll_dice():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, maxdiceroll)
	label.text = str(result)
	return result

func set_maxdiceroll(max):
	maxdiceroll = max
	label.text = "1 - " + str(maxdiceroll)

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("Label")
