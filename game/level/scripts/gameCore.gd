extends Node

const player = preload("res://game/level/scene/player.tscn")
const uiLayer: PackedScene = preload('res://game/level/scene/ui/uiLayer.tscn')
const mapMgrScripts = preload('res://game/level/map/mapMgr.gd')

const attack = preload('res://game/level/scripts/attack.gd')
var parms:Dictionary = {}
var players: Array[Variant] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ui = uiLayer.instantiate()
	ctx.registerService('ui',ui)
	add_child(ui)
	
	var mapMgr:MapMgr = mapMgrScripts.new()
	ctx.registerService('mapMgr',mapMgr)
	add_child(mapMgr)
	
	#此处添加玩家
	players.append(player.instantiate())
	add_child(players[0])
	add_child(attack.new())

func getPlayer():
	return players[0]
	
func newPlayer():
	pass

func removePlayer():
	pass
