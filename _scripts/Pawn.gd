extends Button

class_name Pawn

var player
var locationnow
var buttonstyle
var active

signal selected(pawn_player)

#var pawncolor
#var pawnoutline

func remove_me_fromlocation():
	if(locationnow):
		locationnow.remove_player(self)

func assign_player(_player):
	player = _player
	buttonstyle.set_bg_color(player.color)
	buttonstyle.set_border_color(player.color)
	buttonstyle.set_border_width(SIDE_BOTTOM, 1)
	buttonstyle.set_border_width(SIDE_RIGHT, 1)
	buttonstyle.set_border_width(SIDE_TOP, 1)
	buttonstyle.set_border_width(SIDE_LEFT, 1)
	#buttonstyle.set_content_margin_all(20)
	add_theme_stylebox_override("normal", buttonstyle)
	add_theme_stylebox_override("hover", buttonstyle)
	become_targetable(false)
	#pawncolor.color = player.color

# Called when the node enters the scene tree for the first time.
func _ready():
	#pawncolor = get_node("PawnColor")
	#pawnoutline = get_node("Outline")
	buttonstyle = StyleBoxFlat.new()

func become_targetable(flag):
	self.active = flag
	if(flag):
		buttonstyle.set_border_color(Color(1, 0.05, 0))
	else:
		buttonstyle.border_color = player.color
	
	add_theme_stylebox_override("normal", buttonstyle)
	add_theme_stylebox_override("hover", buttonstyle)
	#pawnoutline.set_visible(flag)

func set_location(location):
	remove_me_fromlocation()
	locationnow = location	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if(!active): return
	selected.emit(player)
