extends Node

class_name Player

var id
var username
var color
var health
var character
var equipment
var gold

var playerui
var readyui
var dicemanager
var locationmanager
var combatmanager

var currentlocation
var playerGuarentAttack = false

var endturnbutton

signal selectedTargets(targets, effect)

# Called when the node enters the scene tree for the first time.
func _ready():
	playerui = get_node("UI Control") 
	var turnmanager = get_node("../../TurnManager")
	readyui = get_node("../../ReadyUI")
	dicemanager = get_node("../../DiceManager")
	locationmanager = get_node("../../LocationsContainer")
	combatmanager = get_node("../../CombatManager")
	endturnbutton = get_node("../../EndTurnButton")
	
	setId()
	setColor()
	health = 0
	gold = 0
	equipment = []
	
	turnmanager.add_player(id)
	turnmanager.playerTurnStarted.connect(on_player_turn_started)
	
	

func setId():
	username = "Player " + str(id)
	playerui.updateName(username)

func setColor():
	playerui.updateColor(color)
	playerui.updatePawn(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turn_start():
	# Check for start of turn effects
	endturnbutton.set_visible(false)
	turn_move()

#Wait for input to roll the dice
func turn_move():
	dicemanager.setup_dice(0)
	dicemanager.playerRolledDice.connect(move_location)

#Phase after you rolled the dice to move to a location
func move_location(result):
	var tempLoc = locationmanager.get_location(result)
	dicemanager.playerRolledDice.disconnect(move_location)
	if (tempLoc == currentlocation):
		await get_tree().create_timer(0.6).timeout
		turn_move()
	else:
		if(currentlocation):
			currentlocation.remove_player(self)
		currentlocation = tempLoc
		currentlocation.add_player(self)
		currentlocation.activate_effect(self)
		turn_combat()

func turn_combat():
	combatmanager.new_player(self)
	playerGuarentAttack = false
	var opponents = combatmanager.show_available_targets()
	#If there are targets to choose, find if you have alternate attack and then go to combat
	#Else go to your next phase immediatly
	if (opponents != []):
		for item in equipment:
			if (item.has_different_attack_roll()): playerGuarentAttack = true
		combatmanager.choose_target(opponents)
	else:
		turn_idle()

func turn_idle():
	endturnbutton.set_visible(true)
	pass

func turn_end():
	pass

func attack_player(amount, player):
	player.receive_combat_damage(amount + get_modify('attack'))

func receive_combat_damage(amount):
	amount -= get_modify('defense')
	receive_damage(amount)

func receive_non_combat_damage(amount):
	amount -= get_modify('nc-defense')
	receive_damage(amount)

func heal(amount):
	health -= amount
	if (health < 0): health = 0

func reveal_card():
	print("reveal card")

# Find equipment modifiers based on stat
func get_modify(stat):
	var modifier = 0
	for item in equipment:
		modifier += item.get_modifier(stat)
	return modifier

func receive_damage(amount):
	if (amount < 0): amount = 0
	health += amount
	playerui.updateDamage(health)

func on_player_turn_started(id):
	if (id != self.id):
		return
	
	#Update UI
	readyui.updateName(username + "'s turn")
	readyui.updateColor(color)
	
	turn_start()

func pawn_available_target(flag):
	playerui.get_pawn().become_targetable(flag)

func get_pawn():
	return playerui.get_pawn()

func get_location():
	return currentlocation

func is_dead():
	return health >= character.maxhealth

func add_equipment(equipment):
	equipment.append(equipment)

func remove_equipment(equipment):
	equipment.erase(equipment)

func select_target(effect):
	pass

func get_equipment_total():
	var amount = 0
	for eq in equipment:
		amount += 1

func draw_card(card):
	if card.is_equipment: add_equipment(card)
	else: #Card is an action
		if (card.color == "green"):
			pass #Choose opponent
		else:
			if (!card.has_auto_targets()): #Card doesn't have automated targets
				pass #Set Choose Targets
			card.do_effect(self, "gamestate")
