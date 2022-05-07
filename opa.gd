const CELL_SIZE = 16
const TO_CELL_CENTER = Vector2(8, 8)
 
const LERP_ACCEL = 0.4
 
var cell_position
 
 
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
 
onready var raycast = $Raycast
 
 
func _ready():
	 cell_position = Vector2(int(position[0] / CELL_SIZE), int(position[1] / CELL_SIZE))
 
 
func _process(delta):
	 sprite.position = sprite.position.linear_interpolate(Vector2(0, 0), LERP_ACCEL)
 
 
func effectivate_movement(dir):
	cell_position += dir
	 position = cell_position * CELL_SIZE + TO_CELL_CENTER
	 sprite.position -= dir * CELL_SIZE
