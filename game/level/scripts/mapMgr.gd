extends Node
class_name MapMgr

var defMap: PackedScene = preload('res://game/level/scene/map.tscn')
var currentMap = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("[INFO]地图管理器就绪")
	loadDefaultMap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func loadDefaultMap():
	print("[INFO][MapMgr]加载默认地图")
	var map:Map = defMap.instantiate()
	var tags:Tags = ctx.tags
	var meta: Array[String] = [tags.noEntry,tags.mapWall,tags.ground]
	for i in meta:
		map.addMeta(i)
		
	add_child(map)
	currentMap = map
	for i in 6:
		map.setBlock(i,6,'yellowBlock')
	