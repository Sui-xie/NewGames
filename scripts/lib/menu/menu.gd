extends Node

const playerMgrScripts = preload("res://scripts/ctx/lib/playerMgr.gd")
const uiLayer: PackedScene = preload('res://scene/uiLayer.tscn')
const mapMgrScripts = preload('res://scripts/ctx/lib/mapMgr.gd')

const attack = preload('res://scripts/lib/attack.gd')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ui = uiLayer.instantiate()
	ctx.registerService('ui',ui)
	add_child(ui)
	
	var playerMgr: PlayerMgr = playerMgrScripts.new()
	ctx.registerService('playerMgr',playerMgr)
	add_child(playerMgr)
	
	var mapMgr:MapMgr = mapMgrScripts.new()
	ctx.registerService('mapMgr',mapMgr)
	add_child(mapMgr)
	
	var p:PlayerMgr = ctx.getService('playerMgr')
	p.addPlayer(0,true)
	add_child(attack.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
