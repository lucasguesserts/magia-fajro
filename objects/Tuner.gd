extends Area2D

var guitarString = null

func play(game : Game):
	self.guitarString._changeRotation()
	game.tween.interpolate_property(game.piano, "volume_db",
		game.piano.volume_db, 0, 0.1, Tween.TRANS_EXPO)
	game.tween.start()
	
