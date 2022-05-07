extends Area2D

func action(Game):
	Game.action(self)
	return true
	
func play(game):
	game.tween.interpolate_property(game.drums, "volume_db",
		game.drums.volume_db, 0, 0.1, Tween.TRANS_EXPO)
	game.tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
