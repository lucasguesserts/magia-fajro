extends Area2D

const movementLength : int = 32
var velocity : Vector2 = Vector2()

var reflect: bool

func _init():
	reflect = false

func _physics_process(delta):
	if not self.position in Global.coordToObject:
		return
	var dir = Vector2(0, 0)
	if Input.is_action_just_pressed("move_left"):
		dir.x -= 1 
	if Input.is_action_just_pressed("move_right"):
		dir.x += 1 
	if Input.is_action_just_pressed("move_up"):
		dir.y -= 1 
	if Input.is_action_just_pressed("move_down"):
		dir.y += 1
	if self.reflect:
		dir.x *= -1
	var destPosition = self.position +  dir * movementLength
	if not (destPosition in Global.coordToObject) :
		var player = Global.coordToObject[self.position]
		Global.coordToObject.erase(self.position)
		self.position = destPosition
		Global.coordToObject[self.position] = destPosition
