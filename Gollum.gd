extends CharacterBody2D

signal enterDone

@onready var size = get_viewport_rect().size

const speed = 130
const leaveLocs = [Vector2(275, -2590), Vector2(230,-2290), Vector2(-140, -2080), Vector2(-75, -1720), Vector2(-60, -1490), Vector2(-80, -1060), Vector2(570, -1100)]

var inCS = "false"
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	inCS = "false"
	i = 0
	global_position = Vector2(0, -5000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inCS == "true":
		enterTick(delta)
	elif inCS == "leave":
		exitTick()


func exitTick():
	var target = leaveLocs[i]
	var dir = target - global_position
	if dir.length() > 15:
		dir = dir.normalized()
		velocity = dir * speed
		rotation = dir.angle() - 10 * PI / 18
	else:
		if velocity != Vector2.ZERO:
			pass
		if not i == 6:
			i += 1
			pass
		else:
			velocity = Vector2.ZERO
	move_and_slide()


func enterTick(_delta):
	var target = Vector2(75, -3450)
	var dir = target - global_position
	if dir.length() > 15:
		dir = dir.normalized()
		velocity = dir * speed
		rotation = dir.angle() - 10 * PI / 18
	else:
		if velocity != Vector2.ZERO:
			enterDone.emit()
		velocity = Vector2.ZERO
	move_and_slide()


func leave():
	inCS = "leave"



func startEnter():
	show()
	global_position = Vector2(75, -(size.y / 2) + (size.y / 5) - 3500)
	inCS = "true"
