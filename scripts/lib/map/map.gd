extends TileMapLayer

class_name Map
var meta:Array[String] = []

#名字是键，值0为图集ID，值1为位置ID
const tileSet: Dictionary[String, Array] = {
	"ohno":[0,Vector2i(0,0)],
	"yellowBlock":[1,Vector2i(0,0)]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func queryImageId(blockName:String):
	if blockName in tileSet:
		var t = tileSet[blockName]
		return t
	print("[WARN]引用不存在的图集")
	return tileSet['ohno']

func setBlock(x:int,y:int,blockName:String):
	if(x < 0 or x > 32768) or (y<0 or y > 32768):
		print("[WARN]操作非法:地图越界，位置X:",x,"Y:",y)
	var tile = queryImageId(blockName)
	set_cell(Vector2i(x,y),tile[0],tile[1])
	
func addMeta(name):
	if(name in meta):return
	meta.append(name)
	
func removeMeta(name):
	meta.erase(name)