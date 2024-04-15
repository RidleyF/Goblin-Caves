extends CanvasLayer

@onready var i1 = $"Invis Holder/Invis1"
@onready var i2 = $"Invis Holder/Invis2"
@onready var i3 = $"Invis Holder/Invis3"
@onready var player = $"../../Player"

var time = 0
var ingame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	i1.frame = 0
	i2.frame = 0
	i3.frame = 0
	time = 0
	ingame = true
	$"../End".hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var view = $"../../Player".get_viewport_rect().size
	$"../End".size.x = view.x
	$"../End".size.y = view.y
	if ingame == true:
		if not Engine.get_frames_per_second() == 1:
			time += 1 / Engine.get_frames_per_second()
		else:
			time += delta
	for i in range(3):
		if i + 1 <= player.health:
			get_node("Heart Container/Heart" + str(i + 1)).show()
		else:
			get_node("Heart Container/Heart" + str(i + 1)).hide()
	if player.hasRing == true:
		i1.show()
		i2.show()
		i3.show()
		var minus = 3
		if player.iTime <=  8 - (8.0 / 3.0):
			minus -= 1
			i3.frame = 8
		if player.iTime <=  8 - (16.0 / 3.0):
			minus -= 1
			i2.frame = 8
		if player.iTime <=  8 - (24.0 / 3.0):
			minus -= 1
			i1.frame = 8
		if minus > 0:
			minus = "Invis Holder/Invis" + String.num(minus)
			minus = get_node(minus)
			minus.frame = fmod(8 - player.iTime, 8.0 / 3.0) * 3
	else:
		i1.hide()
		i2.hide()
		i3.hide()


func end(body: Node2D):
	if body == $"../../Player":
		ingame = false
		$"../End".show()
		$"../End/Time".text = "Your time: " + String.num(time, 2)

func reTry():
	$"../End".hide()
	$"../../Player".reset()
	$"../../Player".title = true


