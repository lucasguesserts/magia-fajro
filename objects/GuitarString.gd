extends Area2D

const ROTATION = {
	'UP': PI/2,
	'RIGHT': 0,
	'LEFT': PI,
	'DOWN': 3*PI/2,
}

var currentRotation = 'LEFT'
var intensity : int = 3

func _ready():
	self.rotation = ROTATION[currentRotation]

func _changeRotation():
	if self.currentRotation == 'LEFT':
		self.currentRotation = 'UP'
		self.rotation = ROTATION[currentRotation]
	elif currentRotation == 'UP':
		self.currentRotation = 'RIGHT'
		self.rotation = ROTATION[currentRotation]
	elif currentRotation == 'RIGHT':
		self.currentRotation = 'DOWN'
		self.rotation = ROTATION[currentRotation]
	elif currentRotation == 'DOWN':
		self.currentRotation = 'LEFT'
		self.rotation = ROTATION[currentRotation]
	else:
		raise()

func getJump():
	var direction : Vector2 = Vector2.ZERO
	if self.currentRotation == 'LEFT':
		direction = Vector2.LEFT
	elif self.currentRotation == 'UP':
		direction = Vector2.UP
	elif self.currentRotation == 'RIGHT':
		direction = Vector2.RIGHT
	elif self.currentRotation == 'DOWN':
		direction = Vector2.DOWN
	else:
		raise()
	return Global.movementLength * self.intensity * direction
	
