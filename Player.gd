extends CharacterBody2D

signal reached
signal restart

const speed = 125

var invis := false
var health := 3
var hasRing:bool = false

var title = true

var inCS:bool = false
var seenCS:bool = false

var iFrame:int = 0
var iTime:float = 8.0
# invis time, in something, idk

@onready var size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(-75, 164.5)
	rotation = 0
	$"../Background".show()


func i_process():
	if Input.is_action_pressed("invis"):
		iFrame += 1
		if iTime > 0.0:
			invis = true
			$Sprite2D.hide()
		else:
			invis = false
			$Sprite2D.show()
		if is_zero_approx(fmod(iFrame, 16)):
			iTime -= 1.0 / 3.0
	else:
		invis = false
		$Sprite2D.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if inCS:
		cutScene()
	elif title == true:
		pass
	else:
		userControl()
	backgroundSet()
	move_and_slide()


func cutScene():
	var target = Vector2(75, -3400)
	var dir = target - global_position
	if dir.length() > 20:
#		dir = Vector2.from_angle(roundf(dir.angle() / (PI / 4)) * (PI / 4))
		dir = dir.normalized()
		velocity = dir * speed * 1.5
#		velocity *= 0.65
		rotation = dir.angle() + (PI / 2)
	else:
		if velocity != Vector2.ZERO:
			reached.emit()
		velocity = Vector2.ZERO
		rotation = 0



func userControl():
	if hasRing:
		i_process()
#	if Input.is_action_just_pressed("ui_accept"):
#		global_position = Vector2(1500, -1300)
	var vector = Input.get_vector("left", "right", "up", "down")
	if vector:
		rotation = vector.angle() + PI / 2
	velocity += vector.normalized() * speed
	velocity *= 0.65
	var swordPos = Vector2(global_position.x + (cos(rotation + 3.7)) * 17, global_position.y + (sin(rotation + 3.7)) * 17)
	$Area2D.global_position = swordPos
	if Input.is_action_just_pressed("sword"):
		$"Area2D/CollisionShape2D".disabled = false
		$"Area2D/StaticBody2D/CollisionShape2D2".disabled = false
		$PointLight2D.show()
		$"Area2D/sword".show()
	if Input.is_action_just_released("sword"):
		$"Area2D/CollisionShape2D".disabled = true
		$"Area2D/StaticBody2D/CollisionShape2D2".disabled = true
		$PointLight2D.hide()
		$"Area2D/sword".hide()

func _on_escape_body_entered(body):
	if body == $".":
		if hasRing:
			$"../walls/StaticBody2D/CollisionPolygon2D".set_deferred("disabled", true)


func _on_escape_body_exited(body):
	if body == $".":
		$"../walls/StaticBody2D/CollisionPolygon2D".set_deferred("disabled", false)


func backgroundSet():
	get_node("../Background").position = position
	get_node("../Background").mesh.size = Vector3(size.x, 1, size.y)


func pickUpRing(body):
	if body == $".":
		hasRing = true
		$"../Ring".hide()


func startCS(body):
	if body == $".":
		if seenCS == false:
			$"Area2D/CollisionShape2D".set_deferred("disabled", true)
			$"Area2D/StaticBody2D/CollisionShape2D2".set_deferred("disabled", true)
			$PointLight2D.hide()
			$"Area2D/sword".hide()
			$Sprite2D.show()
			invis = false
			inCS = true
			seenCS = true


func reset():
	global_position = Vector2(-75, 164.5)
	health = 3
	invis = false
	hasRing = false
	$"../Ring".show()
	inCS = false
	seenCS = false
	iFrame = 0
	iTime = 8.0
	_ready()
	restart.emit()



func takeDamage(body: Node2D):
	if body == $"../escape/Goblin" or body == $"../escape/Goblin2":
		health -= 1
		if health <= 0:
			$"../HUD/ColorRect".gameOver()
		else:
			var change: Vector2 = body.global_position - global_position
			velocity += (-40 * change).rotated(randf_range(-PI / 9, PI / 9))
