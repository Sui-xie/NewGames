extends Node

var peer:ENetMultiplayerPeer
@export var player:PackedScene
@export var Players:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var user_args = OS.get_cmdline_user_args()
	if "--host" in user_args:
		start_as_host()
	elif "--join" in user_args:
		start_as_client()
	print(user_args)
		
	ctx.currentScene = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_as_client(port = 1099):
	peer = ENetMultiplayerPeer.new()
	var e = peer.create_client('localhost',port)
	if e != OK:
		print("[ERROR]发生错误，错误码:",e)
		return
	multiplayer.multiplayer_peer = peer

func start_as_host(port=1099):
	peer = ENetMultiplayerPeer.new()
	var e := peer.create_server(port,100)
	if e == OK:
		multiplayer.multiplayer_peer = peer
		spawnPlayer(peer.get_unique_id())
		multiplayer.peer_connected.connect(spawnPlayer)
		return
	print("[ERROR]发生错误，错误码:",e)

func spawnPlayer(id):
	var p:PlayerTest = player.instantiate()
	p.set_multiplayer_authority(id)
	p.name = "player%d" % id
	p.id = id;
	p.team = id;
	Players.add_child(p)
	
func clientConnect(id):
	if multiplayer.is_server():
		spawnPlayer(id)
		
	
