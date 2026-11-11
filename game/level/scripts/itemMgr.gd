extends Node
class_name ItemMgr

var items:Dictionary = {}#顺序列表，键为数字id，值为一个数组，表达初始化时的parms
var itemTable:Dictionary[String,PackedScene] = {}#存储物品的名字和路径
var cursor:int = 0

func _ready() -> void:
	ctx.on("playerJoin",syncItem)
	ctx.on("nextLevel",clearItem)

func clearItem():
	for x in items:
		var item:Item = items[x]
		item.queue_free()
	items = {}
	cursor = 0

#通过物品名和命名空间查找一个物品
@rpc("any_peer","call_local","reliable")
func addItem(name1:String,parms = {},nameSpace:String="vanilla",x:int = 0,y:int = 0):
	var itemName:String = nameSpace + (':' + name1)
	if itemName in itemTable:
		var item:PackedScene = itemTable[itemName]
		var id:int = cursor
		cursor += 1
		var i:Item = item.instantiate()
		i._private_id = id
		i._private_nameScpace = nameSpace
		i._private_name = name1
		i.parms = parms
		i.position = Vector2(x,y)
		add_child(i)
		items[id] = i
		return id
	else:
		print("[ERROR]找不到名为: ",itemName," 的物品")
		return -1

#移除一个已经添加的物品
@rpc("any_peer","call_local","reliable")
func removeItem(id):
	if not(id in items):
		print("[ERROR]找不到ID为:",id,"的物品")
		return
	var item:Item = items[id]
	item.queue_free()
	items.erase(id)
	
#注册一个新物品到映射表
func regNewItem(iName:String,res:PackedScene,nameSpace:String="vanilla"):
	#print("[INFO]注册物品:",nameSpace + (':' + iName))
	var itemName = nameSpace + (':' + iName)
	if itemName in itemTable:
		print("[WARN]物品:",itemName,"已经被注册过了！")
		return
	itemTable[itemName] = res

#联机同步，将物品节点列表反序列化为字典传输
@rpc("any_peer","call_local","reliable")
func syncItemMgr(itemList,targetCursor):
	if itemList.size() == 0:return
	toItemNode(itemList,targetCursor)
	
	
#把同步过来的注册表变成节点
func toItemNode(itemList,targetCursor):
	cursor = targetCursor
	for i1 in itemList:
		print("[IFNO]反序列项:",i1)
		var data = i1
		var id = data[0]
		var itemName = data[2] + ':' + data[1]
		var parms = data[3]
		var item:PackedScene = itemTable[itemName]
		var i:Item = item.instantiate()
		i._private_id = id
		i._private_nameScpace = data[2]
		i._private_name = data[1]
		i.parms = parms
		i.position = data[4]
		i.rotation = data[5]
		add_child(i)
		items[id] = i

	
#把节点变成列表
func toRegistry():
	#数据结构为:0:物品的ID，1：物品的名字，2:物品的命名空间，3:物品的parms，4:物体的位置，5:物体的旋转
	var list: Array[Array] = []
	for x in items:
		var item:Item = items[x]
		list.append([item._private_id,item._private_name,item._private_nameScpace,item.parms,item.position,item.rotation])
	print("[INFO]序列化结果为:",list)
	return list
		
func syncItem(peerId):
	if(peerId == 1):return
	var list = toRegistry()
	syncItemMgr.rpc_id(peerId,list,cursor)
