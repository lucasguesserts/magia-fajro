extends Area2D

signal change_scene(scene_type)

const movementLength : int = 32
var velocity : Vector2 = Vector2()
var isAlive : bool = true
var GUI = null
var finished: bool = false
var Drums = null
var walkingOver = null
var Game = null

var reflect: bool

func _init():
	reflect = false
	
func _updatePlayerPosition(destinationPosition):
	if self.walkingOver != null:
		var del = self.walkingOver.action(Game)
		if del:
			self.walkingOver.queue_free()
		self.walkingOver = null
	else:
		Global.coordToObject.erase(self.position)
	self.position = destinationPosition
	Global.coordToObject[self.position] = self
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			return true
	return false
	
func _killPlayer():
	Global.coordToObject.erase(self.position)
	self.isAlive = false
	self.visible = false
	GUI.show_level_failed_label(false)
	Global.running = false

func disableBell():
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db",
	$AudioStreamPlayer.volume_db, -80, 0.1, Tween.TRANS_EXPO)
	$Tween.start()

func _finish():
	if not finished:
		self.finished = true
		Global.finished += 1
		self.visible = false
		$WinSound.play()
		if Global.finished == 2:
			GUI.show_level_completed_label(false)
			Global.running = false

func _playDrums():
	$Tween.interpolate_property(Drums, "volume_db",
	Drums.volume_db, 0, 0.1, Tween.TRANS_EXPO)
	$Tween.start()

func _physics_process(_delta):
	if not Global.running:
		return false
	if self.finished:
		return
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
	var destPosition = self.position +  dir * Global.movementLength
	if (destPosition in Global.coordToObject):
		var whatIsAhead = Global.coordToObject[destPosition]
		if whatIsAhead.name.count('Player') > 0:
			pass
		elif whatIsAhead.name.count('Wall') > 0:
			pass
		elif whatIsAhead.name.count('Hole') > 0:
			_killPlayer()
		elif whatIsAhead.name.count('Bell') > 0:
			_finish()
		elif whatIsAhead.name.count('Drums') > 0:
			_playDrums()
			var destObject = Global.coordToObject[destPosition]
			_updatePlayerPosition(destPosition)
			self.walkingOver = destObject
		elif whatIsAhead.name.count('Tuner') > 0:
			whatIsAhead.play()
		elif whatIsAhead.name.count('GuitarString') > 0:
			var jumpPosition : Vector2 = destPosition + whatIsAhead.getJump()
			if (jumpPosition in Global.coordToObject):
				var whatIsAtJumpPosition = Global.coordToObject[jumpPosition]
				if whatIsAtJumpPosition.name.count('Player') > 0:
					_killPlayer()
				if whatIsAtJumpPosition.name.count('Wall') > 0:
					_killPlayer()
				elif whatIsAtJumpPosition.name.count('Hole') > 0:
					_killPlayer()
				elif whatIsAtJumpPosition.name.count('Tuner') > 0:
					_killPlayer()
				elif whatIsAtJumpPosition.name.count('GuitarString') > 0:
					_killPlayer()
				elif whatIsAtJumpPosition.name.count('Bell') > 0:
					_finish()
				else:
					raise()
			else:
				_updatePlayerPosition(jumpPosition)
	else:
		_updatePlayerPosition(destPosition)
	
