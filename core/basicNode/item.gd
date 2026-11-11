extends RigidBody2D
class_name Item
var meta: Array[Variant] = []
var parms:Dictionary = {}#在同步时，这个地方的信息会被同步到其它客户端，物品的transformer会被自动同步过去，也可以用于传递参数
var _private_name:String#物品分配表给它分配的名字，不应该修改
var _private_id:int#物品管理器分配的唯一ID，不应该修改
var _private_nameScpace:String#物品分配表给它分配的命名空间，不应该修改