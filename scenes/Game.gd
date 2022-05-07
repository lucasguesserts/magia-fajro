extends Node2D

class_name Game

signal change_scene(sceneType)

const sizeGrid = 32
var offset : Vector2
onready var curLevel = 0
var needRestart = false
onready var drums : AudioStreamPlayer = $Drums2
onready var piano : AudioStreamPlayer = $Tuner2
onready var bass : AudioStreamPlayer = $Bass2
onready var tuner : AudioStreamPlayer = $Piano
onready var tween : Tween = $Tween 
onready var background: AudioStreamPlayer = $Background2
	
func loadFile(fileName : String):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = file.get_as_text()
	print(content)
	file.close()
	return content

func action(object):
	if object.name.count("Drums"):
		var scene = load("res://objects/Hole.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		var coord = object.position
		instance.position = coord
		Global.coordToObject.erase(object)
		Global.coordToObject[coord] = instance
		return true

func loadJsonFile(fileName : String):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = file.get_as_text()
	var content_as_dictionary = parse_json(content)
	file.close()
	return content_as_dictionary
	
func parseObject(coord : Vector2, object : String):
	coord *= sizeGrid
	coord += offset
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
	elif object == 'D':
		var scene = load("res://objects/Drums.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord
		Global.coordToObject[coord] = instance
	elif object == 'P':
		var scene = load("res://objects/Piano.tscn");
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
		instance.Game = self
		self.add_child(instance);
		instance.position = coord
		instance.Drums = $Drums
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

func createGuitarString(x, y, intensity, rotation):
	var scene = load("res://objects/GuitarString.tscn");
	var instance = scene.instance();
	self.add_child(instance);
	var coord : Vector2 = Vector2(x, y)
	coord *= sizeGrid
	coord += offset
	instance.position = coord
	Global.coordToObject[coord] = instance
	instance.intensity = intensity
	instance.currentRotation = rotation
	return instance

func createTuner(guitarString, x, y):
	var scene = load("res://objects/Tuner.tscn");
	var instance = scene.instance();
	self.add_child(instance);
	var coord : Vector2 = Vector2(x, y)
	coord *= sizeGrid
	coord += offset
	instance.position = coord
	Global.coordToObject[coord] = instance
	instance.guitarString = guitarString

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

func buildGuitarString(json):
	var guitarString = createGuitarString(
		json['GuitarString']['position']['x'],
		json['GuitarString']['position']['y'],
		json['GuitarString']['intensity'],
		json['GuitarString']['rotation']
	)
	createTuner(
		guitarString,
		json['Tuner']['position']['x'],
		json['Tuner']['position']['y']
	)

func _init():
	print('Running')
	
func buildMusicType(jsonFile):
	var typeMusic = jsonFile['sounds']['type']
	if typeMusic == 1:
		drums = $Drums1 
		piano = $Piano1
		bass = $Bass1
		background = $Background1
	elif typeMusic == 2 :
		drums = $Drums2
		piano = $Tuner2
		bass = $Bass2
		tuner = $Piano2
		background = $Background2
	else:
		assert(false)

func _ready():
	var mapFile = loadFile("res://maps/map2.txt")
	var lines = mapFile.split("\n",false)
	var rows = lines.size()
	var cols = lines[0].length()
	var rect = get_viewport_rect()
	offset = Vector2.ZERO
	offset.x = (rect.size.x - 32*cols) / 2.0
	offset.y = (rect.size.y - 32*rows + $GUI.get_size().y) / 2.0
	
	buildMap(mapFile)
	var jsonFile = loadJsonFile("res://maps/map2_extras.json")
	buildGuitarString(jsonFile)
	buildMusicType(jsonFile)
	
	$GUI.hide_level_completed_label()
	$GUI.hide_level_failed_label()
	$GUI.set_level_name("Level " + str(curLevel + 1))
	$GUI.show()
	
	$Tween.interpolate_property(background, "volume_db",
		background.volume_db, 0, 0.1, Tween.TRANS_EXPO)
	$Tween.start()
	
	
