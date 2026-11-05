extends Node2D

const bus = preload("res://scripts/ctx/lib/eventBus.gd")
const playerMgr = preload("res://scripts/ctx/lib/playerMgr.gd")
const uiLayer: PackedScene = preload('res://scene/uiLayer.tscn')

const attack = preload('res://scripts/lib/attack.gd')

# 该脚本中，不应该使用ctx的任何服务，还未加载
func _ready() -> void:
	ctx.root = self
	
	var eventBus: EventBus = bus.new()
	ctx.registerService('eventBus',eventBus)
	ctx.add_child(ctx.getService('eventBus'))
	
	var ui = uiLayer.instantiate()
	ctx.registerService('ui',ui)
	self.add_child(ui)
	
	var mgr: PlayerMgr = playerMgr.new()
	ctx.registerService('playerMgr',mgr)
	ctx.add_child(mgr)
	
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start():
	var p:PlayerMgr = ctx.getService('playerMgr')
	p.addPlayer(0,true)
	add_child(attack.new())
