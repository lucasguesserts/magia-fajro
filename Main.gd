extends Node

var coordToObject = {}
const sizeGrid = 32
const liftRight = Vector2(sizeGrid/5, 0) # to centralize the player
const offSet = Vector2(30, 30)

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
	elif object == 'P':
		var scene = load("res://objects/Player.tscn");
		var instance = scene.instance();
		self.add_child(instance);
		instance.position = coord + liftRight
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

func _ready():
	print('Running')
	var mapFile = loadFile("res://maps/map0.txt")
	buildMap(mapFile)
