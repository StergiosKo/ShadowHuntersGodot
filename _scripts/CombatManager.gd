extends Node

class_name CombatManager

var locationmanager
var dicemanager
var gamemanager
var passbutton

var currentplayer
var availableOpp
var currentlychoosing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	locationmanager = get_node("../LocationsContainer")
	gamemanager = get_node("../GameManager")
	dicemanager = get_node("../DiceManager")
	passbutton = get_node("../PassButton")
	passbutton.pressed.connect(pass_clicked)
	passbutton.set_visible(false)

func new_player(player):
	currentplayer = player

func show_available_targets():
	var opponents = locationmanager.get_location_players(currentplayer)
	opponents.append_array(locationmanager.get_neighbour_players(currentplayer))
	availableOpp = opponents
	for opp in opponents:
		opp.pawn_available_target(true)
	return opponents

func choose_target(opponents):
	currentlychoosing = true
	passbutton.set_visible(true)
	gamemanager.update_tooltip_text("Choose target")
	for opp in opponents:
		var crPawn = opp.get_pawn()
		crPawn.selected.connect(target_clicked)
		#crPawn.connect(self, _on_button_pressed)

func target_clicked(opponent):
	currentlychoosing = false
	passbutton.set_visible(false)
	if (currentplayer.playerGuarentAttack): dicemanager.setup_dice(2)
	else: dicemanager.setup_dice(1)
	var result = dicemanager.roll_dice()
	currentplayer.attack_player(result, opponent)
	for opp in availableOpp:
		opp.pawn_available_target(false)
	currentplayer.turn_idle()

func pass_clicked():
	if (!currentlychoosing): return
	passbutton.set_visible(false)
	for opp in availableOpp:
		opp.pawn_available_target(false)
	currentplayer.turn_idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
