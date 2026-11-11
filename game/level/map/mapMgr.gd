extends Node
class_name MapMgr

var playerSpawnPoint: Array[Dictionary] = []
var map:Node
var yellowBlock:PackedScene
var redBlock:PackedScene
var currentMapName:Array[String]
var itemMgr:ItemMgr = ctx.getService('itemMgr')#比较自信我的加载排序
var mapTable:Array[Array] = []

func _ready() -> void:
	map = Node.new()
	add_child(map)
	resetTable()

	yellowBlock = load("res://game/level/scene/map/yellowBlock.tscn")
	redBlock = load ("res://game/level/scene/map/redBlock.tscn")
	var lobby = load("res://game/level/map/levels/lobby.gd")
	
	regLevel("lobby",lobby.new())
	regBlock("ohno",redBlock)
	regBlock("yellowBlock",yellowBlock)

#方块集合，键是"命名空间:方块名字"，值为方块的场景，实现mapBlock.gd
var blockSet: Dictionary[String, PackedScene] = {}
var levelSet:Dictionary[String,Level] = {}

func resetTable():
	mapTable.resize(99)
	for i in range(99):
		var row: Array = []
		row.resize(99)
		row.fill(null)
		mapTable[i] = row

#输入名字应该自带命名空间
func setBlock(x:int,y:int,blockName,parms:Dictionary):
	if (x <0 or x >=100) or (y < 0 or y >= 100):
		print("[WARN]地图尺寸越界！")
		return
	if not(mapTable[x][y] == null):
		mapTable[x][y].queue_free()
	var b:PackedScene = blockSet[blockName]
	var block:MapBlock = b.instantiate() 
	var tx: int = x*100
	var ty: int = y *100
	block.position = Vector2(tx,ty)
	block.parms = parms.duplicate(true)
	map.add_child(block)
	mapTable[x][y] = block
	
func setItem(x:int,y:int,itemName:String,parms:Dictionary,nameSpace:String = "vanilla"):
	if (x <0 or x >=100) or (y < 0 or y >= 100):
		print("[WARN]地图尺寸越界！")
		return
	itemMgr.addItem(itemName,parms,nameSpace,x,y)
	
	
#每个元素按照位置写入参数，0:x位置，1:y位置，2:方块带命名空间名，3:parms（没有就传空字典），4:type(如果没有就是block)，5:物品命名空间(如果没有就是vanilla)
func loadLevel(level:Level):
	var levelArray: Array[Array] = level._exportMap()
	for x in levelArray:
		if x[4] == "block" or x[4] == null:
			var n:String
			if x[5] == null or x[5] == '':
				n ="vanilla:" + x[2]
			else:
				n = x[5] + ':' + x[2]
			setBlock(x[0],x[1],n,x[3])
		if x[4] == "item":
			var space:String
			if x[5] == '' or x[5] == null:
				space = "vanilla"
			if(x[5] == null):
				setItem(x[0],x[1],x[2],x[3])
			else:
				setItem(x[0],x[1],x[2],x[3],x[5])

	
func regBlock(name:String,blockScene:PackedScene,nameSpace:String = "vanilla"):
	blockSet[nameSpace + ':' + name] = blockScene

func regLevel(levelName,levelScene:Level,nameSpace:String = "vanilla"):
	levelSet[nameSpace + ':' + levelName] = levelScene

@rpc("any_peer","call_local","reliable")
func nextLevel(levelName:String = "random",nameSpace:String = "vanilla"):
	map.queue_free()
	map = Node.new()
	resetTable()
	add_child(map)
	var level:String
	if levelName == "random":
		var levelsKey = levelSet.keys()
		level = levelsKey.pick_random()
	else:
		level = nameSpace + ':' + levelName
		if not(level in levelSet):
			print("[ERROR]要加载的地图不存在！")
			level = "vanilla:lobby" 
	var mapArrayData: Level = levelSet[level]
	loadLevel(mapArrayData)
	currentMapName = [levelName,nameSpace]
	ctx.emit("nextLevel",levelName,nameSpace)

#客户端连接之后询问服务端当前正在游玩什么地图并且更换
@rpc("any_peer","call_local","reliable")
func toCureentMap(levelName,nameSpace:String = "vanilla"):
	nextLevel(levelName,nameSpace)