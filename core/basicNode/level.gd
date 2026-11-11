extends Node
class_name Level

var meta:Array[Variant] = []

#地图管理器会调用该方法来输出地图，要求地图格式为二维无序数组
#每个元素按照位置写入参数，0:x位置，1:y位置，2:方块带命名空间名，3:parms（没有就传空字典），4:type(如果没有就是block)，5:物品命名空间(如果没有就是vanilla)
func _exportMap() -> Array[Array]:
	print("[关卡未重写_exportMap方法]")
	return []