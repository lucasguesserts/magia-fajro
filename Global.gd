extends Node

var coordToObject = {}

const movementLength : int = 32

enum SceneType {SelectPack, Help, Quit, Main, SelectLevel, Game}

var running = false
var finished = 0
