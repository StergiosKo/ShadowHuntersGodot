extends Control

class_name Tooltip

var colorbg
var label

func set_text(text):
	if(!label): label = get_node("TooltipBg/TooltipLabel")
	label.text = text
	colorbg.set_visible(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	colorbg = get_node("TooltipBg")
	label = get_node("TooltipBg/TooltipLabel")
	colorbg.set_visible(false)

func finish_tip():
	colorbg.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
