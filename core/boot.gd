extends Node2D
class_name Boot

const bus = preload("res://core/eventBus.gd")

@export var firstOneScene:PackedScene = preload("res://game/menu/menu.tscn");

# 该脚本中，不应该使用ctx的任何服务，还未加载
func _ready() -> void:
	name = "boot"
	ctx.boot = self
	ctx.currentScene =firstOneScene.instantiate()
	var eventBus: EventBus = bus.new()
	ctx.registerService('eventBus',eventBus)
	ctx.currentScene.add_child(ctx.getService('eventBus'))
	self.add_child(ctx.currentScene)
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start():
	pass
