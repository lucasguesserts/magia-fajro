extends Node

const sizeGrid = 32
const offSet = Vector2(sizeGrid, sizeGrid)
var coordToObject = {}
	
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
		coordToObject[coord] = instance
	elif object == '1' || object == '2':
		var scene = load("res://objects/Player.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord
		if object == '1':
			instance.reflect = true
		coordToObject[coord] = instance

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

func _init():
	print('Running')
	var mapFile = loadFile("res://maps/map0.txt")
	buildMap(mapFile)
