extends Node

var itemMgr:ItemMgr = ctx.getService('itemMgr')
var mapMgr:MapMgr = ctx.getService('mapMgr')

func regAll():
	_regBlock()
	_regItem()
	_regLevel()
	print("[INFO]全部物品注册完成")
	
func _regItem():
	var steelPipeGun: PackedScene = load("res://game/level/scene/weapon/steelPipeGun.tscn")
	itemMgr.regNewItem("steelPipeGun",steelPipeGun)
	
func _regBlock():
	var brick: PackedScene = load("res://game/level/scene/map/block/brick.tscn")
	mapMgr.regBlock("redBrick",brick)
	var redBlock:PackedScene = load ("res://game/level/scene/map/redBlock.tscn")
	mapMgr.regBlock("ohno",redBlock)
	var yellowBlock:PackedScene = load("res://game/level/scene/map/yellowBlock.tscn")
	mapMgr.regBlock("yellowBlock",yellowBlock)
	
func _regLevel():
	var lobby = load("res://game/level/map/levels/lobby.gd")
	mapMgr.regLevel("lobby",lobby.new())