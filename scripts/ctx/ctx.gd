extends Node
class_name Ctx

@export var gravity:float = -1600

const sceneList: Dictionary[String, Variant] = {
	"error":"res://scene/other/errorScene.tscn",
	"menu":"res://scene/menu/menu.tscn",
	"level":'res://scene/game/level.tscn'
}

var players := []
var globalService:Dictionary[String,Node] = {}#全局服务
var service:Dictionary[String,Node] = {}#普通服务
var boot:Node2D
var currentScene:Node2D

const bus = preload("res://scripts/ctx/lib/eventBus.gd")

func _ready() -> void:
	pass

func on(event: String, callback:
	Callable) -> int:return service["eventBus"].on(event,callback)

func off(id: int) -> bool:
	return service["eventBus"].off(id)

func emit(event: String, ...args) -> void:
	service["eventBus"].callv("emit", [event] + args)

func registerGolbalService(serviceName:String,s):
	globalService[serviceName] = s

func getGolbalService(serviceName:String) -> Node:
	if(globalService.has(serviceName)):
		return globalService[serviceName]
	else:
		return null

func registerService(serviceName:String,s):
	service[serviceName] = s

func getService(serviceName:String) -> Node:
	if(service.has(serviceName)):
		return service[serviceName]
	else:
		return null
		
func getBoot()->Node2D:
	if boot == null:print('[WARN]有节点拿到了空的Boot节点')
	return boot
		
func getMainScene() -> Node2D:
	if currentScene == null:print('[WARN]有节点拿到了空的主场景节点')
	return currentScene
	
#该方法在boot时禁用,在该方法内禁止使用事件总线
func switchMainScene(sceneId:String):
	var sceneName:String;
	if sceneId in sceneList:
		sceneName = sceneId
	else:
		sceneName = "error"
	for serviceName in service:
			service[serviceName].free()
	service = {}
	currentScene.free()
	
	var s = load(sceneList[sceneName]).instantiate()
	currentScene = s
	var eventBus: EventBus = bus.new()
	registerService('eventBus',eventBus)
	s.add_child(eventBus)
	boot.add_child(s)
