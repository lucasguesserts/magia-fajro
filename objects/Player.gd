extends Area2D

const movementLength : int = 16
var velocity : Vector2 = Vector2()

func _physics_process(delta):
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = ceil(velocity.x)
	velocity.y = ceil(velocity.y)
	self.position += velocity * movementLength
