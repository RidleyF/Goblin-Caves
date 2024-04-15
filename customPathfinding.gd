extends CharacterBody2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var sword: StaticBody2D = $"../../Player/Area2D/StaticBody2D"
@onready var defaultLoc: Vector2 = global_position
@onready var targ: Vector2 = defaultLoc
@onready var ray: RayCast2D = $RayCast2D

const speed = 135

var damageVel: Vector2
# Velocity after taking damage
var shouldFollow:bool = false
var health:int = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	reset()


func _process(_delta):
	ray.rotation = (player.global_position - global_position).angle() - (PI / 2)
	if ray.is_colliding():
		if player.invis == false:
			var hitting = ray.get_collider()
			if hitting == player or hitting == sword:
				shouldFollow = true
				targ = player.global_position
			else:
				shouldFollow = false
				targ = defaultLoc
#		else:
#			targ = defaultLoc
	if (defaultLoc - global_position).length() > 1000:
		targ = defaultLoc
	elif (targ - global_position).length() < 5:
		targ = Vector2(0, 0)
	goToTarget(targ)


func goToTarget(target:Vector2):
	if target != Vector2(0, 0):
		var dir = target - global_position
		if dir:
			dir = Vector2.from_angle(roundf(dir.angle() / (PI / 4)) * (PI / 4))
		velocity = (dir.normalized() * speed) + damageVel
		damageVel *= 0.65
		$Sprite2D.rotation = dir.angle() + (PI / 2)
		move_and_slide()
	
func reset():
	global_position = defaultLoc
	shouldFollow = false
	$"CollisionShape2D".set_deferred("disabled", false)
	health = 2
	show()
	damageVel = Vector2.ZERO
	targ = Vector2(0, 0)

func takeDamage(body: Node2D):
	if body == $".":
		health -= 1
		if health <= 0:
			hide()
			$"CollisionShape2D".set_deferred("disabled", true)
		var change: Vector2 = player.global_position - global_position
		damageVel = (-40 * change).rotated(randf_range(-PI / 9, PI / 9))
