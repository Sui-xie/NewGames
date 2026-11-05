extends Node
class_name Ctx

var players := []
var service:Dictionary[String,Node] = {}
var root

const bus = preload("res://scripts/ctx/lib/eventBus.gd")
const playerMgr = preload("res://scripts/ctx/lib/playerMgr.gd")

func _ready() -> void:
	root = get_node('/root')
	service["eventBus"] = bus.new()
	add_child(service['eventBus'])
	service["playerMgr"] = playerMgr.new()
	add_child(service['playerMgr'])

func on(event: String, callback:
	Callable) -> int:return service["eventBus"].on(event,callback)

func off(id: int) -> bool:
	return service["eventBus"].off(id)

func emit(event: String, ...args) -> void:
	service["eventBus"].callv("emit", [event] + args)

func registerService(name:String,service):
	service[name] = service
	
func getService(name:String):
	if(service.has(name)):
		return service[name]
	else:
		return null
	
