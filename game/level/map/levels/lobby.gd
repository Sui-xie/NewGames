extends Level

#地图管理器会调用该方法来输出地图，要求地图格式为二维无序数组
#每个字典按照位置写入参数，0:x位置，1:y位置，2:方块带命名空间名，3:parms（没有就传空字典）
func _exportMap() -> Array[Array]:
	var arr:Array[Array] = []
	for x in 6:
		arr.append(newBlock(x,5))
		arr.append(newRed(x,10))
	print("数组为:",arr)
	return arr
	
func newBlock(x,y):
	return [x,y,"vanilla:yellowBlock",{}]
	
func newRed(x,y):
	return [x,y,"vanilla:ohno",{}]
