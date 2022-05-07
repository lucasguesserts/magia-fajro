extends Node

signal change_scene(sceneType)

const sizeGrid = 32
onready var offSet = Vector2(sizeGrid, sizeGrid + $GUI.get_size().y)
onready var curLevel = 0
var needRestart = false
	
func loadFile(fileName : String):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = file.get_as_text()
	print(content)
	file.close()
	return content
	
func parseObject(coord : Vector2, object : String):
	coord *= sizeGrid
	coord += offSet
	if object == '#':
		var scene = load("res://objects/Wall.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord
		Global.coordToObject[coord] = instance
	elif object == 'X':
		var scene = load("res://objects/Hole.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord
		Global.coordToObject[coord] = instance
	elif object == '+':
		var scene = load("res://objects/Bell.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord
		Global.coordToObject[coord] = instance
	elif object == '1' || object == '2':
		var scene = load("res://objects/Player.tscn");
		var instance = scene.instance();
		instance.connect("change_scene", self, "change_scene")
		instance.GUI = $GUI
		self.add_child(instance);
		instance.position = coord
		if object == '1':
			instance.reflect = true
		Global.coordToObject[coord] = instance

func change_scene(sceneType):
	emit_signal("change_scene", sceneType)

func resetGame():
	needRestart = false
	for pr in Global.coordToObject:
		Global.coordToObject[pr].queue_free()
	Global.coordToObject = {}
	Global.finished = 0

func _unhandled_input(event):
	if event is InputEventKey and not Global.running and not needRestart:
		needRestart = true
	elif event is InputEventKey and needRestart:
		resetGame()
		emit_signal("change_scene", Global.SceneType.Main)

func buildMap(map):
	var i = 0
	var j = 0
	for h in range(len(map)):
		if(map[h] == '\n'):
			j += 1
			i = 0
			continue
		parseObject(Vector2(i, j), map[h])
		i += 1
	Global.running = true

func _init():
	print('Running')

func _ready():
	var mapFile = loadFile("res://maps/map1.txt")
	buildMap(mapFile)
	$GUI.hide_level_completed_label()
	$GUI.hide_level_failed_label()
	$GUI.set_level_name("Level " + str(curLevel + 1))
	$GUI.show()
