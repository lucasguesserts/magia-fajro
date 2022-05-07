extends Area2D

func action(Game):
	Game.action(self)
	return true
	
func play(game : Game):
	game.tween.interpolate_property(game.tuner, "volume_db",
		game.tuner.volume_db, 0, 0.1, Tween.TRANS_EXPO)
	game.tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
