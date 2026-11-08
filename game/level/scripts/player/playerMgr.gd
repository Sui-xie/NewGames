extends Node
class_name PlayerMgr

const player = preload("res://game/level/scene/player.tscn")
var players:Dictionary[int,Player] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer","call_remote","reliable")
func addPlayer(id):
	var p:Player = player.instantiate()
	p.id = id;
	p.name = "Player@%d" % id
	players[id] = p
	add_child(p)

@rpc("any_peer","call_remote","reliable")
func removePlayer(id):
	if not players.has(id) or players[id] == null:
		return
	players[id].queue_free()
	players[id] = null
	
func playerJoin(peer):
	if ctx.onlineStatus == "offline":
		peer = 1
	ctx.broadCast.rpc("玩家:",peer,"加入了游戏")
	if not multiplayer.is_server():return
	for i in get_child_count():
		var p:Player = get_child(i)
		addPlayer.rpc_id(peer,p.id)
	addPlayer.rpc(peer)
	addPlayer(peer)

func playerLeave(peer):
	ctx.broadCast.rpc("玩家:",peer,"离开了游戏")
	removePlayer(peer)
	removePlayer.rpc(peer)
