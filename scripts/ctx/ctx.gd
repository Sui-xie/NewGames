extends Node
class_name Ctx

var players := []
var service:Dictionary[String,Node] = {}
var root:Node2D

const bus = preload("res://scripts/ctx/lib/eventBus.gd")
const playerMgr = preload("res://scripts/ctx/lib/playerMgr.gd")

func _ready() -> void:
	pass

func on(event: String, callback:
	Callable) -> int:return service["eventBus"].on(event,callback)

func off(id: int) -> bool:
	return service["eventBus"].off(id)

func emit(event: String, ...args) -> void:
	service["eventBus"].callv("emit", [event] + args)

func registerService(name:String,s):
	service[name] = s

func getMainScene() -> Node2D:
	if root == null:print('[WARN]有节点拿到了空的根节点')
	return root

func getService(name:String):
	if(service.has(name)):
		return service[name]
	else:
		return null
