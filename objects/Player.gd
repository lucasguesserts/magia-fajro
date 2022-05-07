extends Area2D

const movementLength : int = 16
var velocity : Vector2 = Vector2()

func _physics_process(delta):
	var dir = Vector2(0, 0)
	if Input.is_action_just_pressed("move_left"):
		dir.x -= 1 
	if Input.is_action_just_pressed("move_right"):
		dir.x += 1 
	if Input.is_action_just_pressed("move_up"):
		dir.y -= 1 
	if Input.is_action_just_pressed("move_down"):
		dir.y += 1 
	self.position += dir * movementLength
