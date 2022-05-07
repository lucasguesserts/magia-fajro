extends Area2D

const movementLength : int = 32
var velocity : Vector2 = Vector2()
var isDead : bool = false

var reflect: bool

func _init():
	reflect = false
	
func _updatePlayerPosition(destinationPosition):
	Global.coordToObject.erase(self.position)
	self.position = destinationPosition
	Global.coordToObject[self.position] = self
	
func _killPlayer():
	Global.coordToObject.erase(self.position)
	self.isDead = true
	self.visible = false

func _physics_process(_delta):
	if not self.position in Global.coordToObject:
		return
	var dir = Vector2(0, 0)
	if Input.is_action_just_pressed("move_left"):
		dir = Vector2.LEFT
	if Input.is_action_just_pressed("move_right"):
		dir = Vector2.RIGHT
	if Input.is_action_just_pressed("move_up"):
		dir = Vector2.UP
	if Input.is_action_just_pressed("move_down"):
		dir = Vector2.DOWN
	if self.reflect:
		dir.x *= -1
	var destPosition = self.position +  dir * movementLength
	if (destPosition in Global.coordToObject):
		var whatIsAhead = Global.coordToObject[destPosition]
		print(whatIsAhead.name)
		if whatIsAhead.name.count('Wall') > 0:
			pass
		if whatIsAhead.name.count('Hole') > 0:
			_killPlayer()
	else:
		_updatePlayerPosition(destPosition)
