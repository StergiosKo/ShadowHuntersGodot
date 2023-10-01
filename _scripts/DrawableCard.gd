class_name DrawableCard

var cardname
var description
var color
var effects
var cardtype
var cost

var currentgamestate
var currentplayer

func _init(data):
	cardname = data["name"]
	cardtype = data["cardtype"]
	color = data["color"]
	description = data["description"]
	effects = data["effects"]
	cost = data["cost"]


#Returns the value (if it has) based on stat
#Stats are: attack, defense, nc-defense
func get_modifier(stat):
	for effect in effects:
		if (effect['type'] == 'add_stat'):
			if (effect['effecttype'] == stat):
				return effect['value']
	return 0

func has_different_attack_roll():
	for effect in effects:
		if (effect['type'] == 'roll'):
			if (effect['effecttype'] == 'attack'):
				return true
	return false

func do_action_effect(targets, effect):
	for target in targets:
		if (effect['effect_type'] == 'damage'):
			currentplayer.receive_non_combat_damage(effect['value'])
		elif (effect['effect_type'] == 'heal'):
			currentplayer.heal(effect['value'])
		elif (effect['effect_type'] == 'reveal'):
			currentplayer.reveal_card()
		elif (effect['effect_type'] == 'steal'):
			randomize()
			var randomequipment = randi_range(1, target.get_equipment_total)
			var equipment = target.equipment[randomequipment]
			target.remove_equipment(equipment)
			currentplayer.add_equipment(equipment)

func has_auto_target():
	for effect in effects:
		if(effect['type'] == 'auto'):
			return true
	return false

func set_targets(effect):
	if (has_auto_target()):
		var targets = []
		if (effect['target'] == 'self'):
			targets.append(currentplayer)
		return targets
	return null

func play_card(player, gamestate):
	var targets
	currentgamestate = gamestate
	currentplayer = player
	if (has_auto_target()):
		for effect in effects:
			targets = set_targets(effect)
			do_action_effect(targets, effect)
	else:
		for effect in effects:
			targets = player.select_target(effect)
			player.selectedTargets.connect(do_action_effect)


func is_equipment():
	if cardtype == "equipment":
		return true
	elif cardtype == "action":
		return false
