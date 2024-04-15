extends ColorRect

@onready var player = $"../../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.title == true:
		show()
	else:
		hide()


func start():
	player.title = false
	player.reset()


func controls():
	$Window.show()


func closeControls():
	$Window.hide()
