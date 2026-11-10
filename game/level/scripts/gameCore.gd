extends Node

const uiLayer: PackedScene = preload('res://game/level/scene/ui/uiLayer.tscn')
const mapMgrScripts = preload('res://game/level/map/mapMgr.gd')
const playersMgr = preload("res://game/level/scripts/player/playerMgr.gd")
const itemMgr1 = preload("res://game/level/scripts/itemMgr.gd")

var parms:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if parms.is_empty():
		createGame()
		ctx.onlineStatus = "offline"
		return
	if(parms['type'] == 'joinGame'):
		joinGame()
		ctx.onlineStatus = "online"
		return
	if(parms['type'] == 'createGame'):
		createGame()
		ctx.onlineStatus = "online"
		return
	if(parms['type'] == 'play'):	
		createGame()
		ctx.onlineStatus = "offline"
		return
	print("[ERROR]启动失败，启动参数未知,参数为:",parms)
	
func createGame() -> int:
	initGameScene()
	if parms.is_empty() or parms.get("type") == "play":
		# 单机
		multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
		ctx.getService('playerMgr').playerJoin(multiplayer.get_unique_id())
		var a:ItemMgr = ctx.getService('itemMgr')
		a.addItem("steelPipeGun")
	else:
		var net := ENetMultiplayerPeer.new()
		var err := net.create_server(parms['port'], parms['maxPlayer'])
		if err != OK:
			push_error("create_server failed: %d" % err)
			ctx.switchMainScene('menu')
			ctx.onlineStatus = 'offline'
			return err
		multiplayer.multiplayer_peer = net
		var mgr:PlayerMgr = ctx.getService('playerMgr')
		multiplayer.peer_connected.connect(mgr.playerJoin)
		multiplayer.peer_disconnected.connect(mgr.playerLeave)
		ctx.getService('playerMgr').playerJoin(multiplayer.get_unique_id())
		ctx.isServer = true
		var a:ItemMgr = ctx.getService('itemMgr')
		a.addItem("steelPipeGun")
		
	return OK
	
func joinGame():
	var peer
	var ip = parms['ip']
	var port = parms['port']
	var net:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer = net.create_client(ip,port)
	if peer == OK:
		multiplayer.multiplayer_peer = net
		initGameScene()
	else:
		ctx.onlineStatus = 'offline'
		ctx.switchMainScene('menu')
		ctx.broadCast("[ERROR]连接失败，错误码:",peer)


func initGameScene():
	var ui = uiLayer.instantiate()
	ctx.registerService('ui',ui)
	add_child(ui)
	
	var mapMgr:MapMgr = mapMgrScripts.new()
	ctx.registerService('mapMgr',mapMgr)
	add_child(mapMgr)
	
	var playerMgr = playersMgr.new()
	ctx.registerService('playerMgr',playerMgr)
	add_child(playerMgr)
	
	var itemMgr:ItemMgr = itemMgr1.new()
	ctx.registerService('itemMgr',itemMgr)
	add_child(itemMgr)
	
	var steelPipeGun = load("res://game/level/scene/weapon/steelPipeGun.tscn")
	itemMgr.regNewItem("steelPipeGun",steelPipeGun)
	
func _exit_tree() -> void:
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		ctx.isServer = false
		
