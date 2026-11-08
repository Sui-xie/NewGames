extends Node
class_name Menu

@export var selectMode:PackedScene
@export var joinGame:PackedScene
@export var createGame:PackedScene

var currentScene:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentScene = selectMode.instantiate()
	currentScene.menu = self
	add_child(currentScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switchTo(sceneName):
	currentScene.queue_free()
	if sceneName == "select":
		currentScene = selectMode.instantiate()
		currentScene.menu = self
		add_child(currentScene)
		return
	if sceneName == "join":
		currentScene = joinGame.instantiate()
		currentScene.menu = self
		add_child(currentScene)
		return
	if sceneName == "create":
		currentScene = createGame.instantiate()
		currentScene.menu = self
		add_child(currentScene)
		return
		
func createRoom(port,playerNumber):
	var parms: Dictionary[Variant, Variant] = {
		"type":"createGame",
		"maxPlayer":int(playerNumber),
		"port":int(port)
	}
	print("[DEBUG]PORT:",port,"NUMBER:",playerNumber)
	ctx.switchMainScene('level',parms)
	
func joinRoom(ip,port):
	var parms: Dictionary[Variant, Variant] = {
		"type":"joinGame",
		"ip":ip,
		"port":int(port)
	}
	print("[DEBUG]IP:",ip,"PORT:",port)
	ctx.switchMainScene('level',parms)

func play():
	var parms: Dictionary[Variant, Variant] = {
		"type":"play",
	}
	ctx.switchMainScene('level',parms)
