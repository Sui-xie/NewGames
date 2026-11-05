extends Node
class_name PlayerMgr

var players = []
var root:Node2D = ctx.getMainScene()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("[INFO]PlayerMgr Ready")
	if(root == null):
		push_error('[ERROR]root is null')
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addPlayer(id,client:bool = false):
	#print("[INFO]即将添加一个玩家到节点:")
	var p1: PackedScene = load('res://scene/player.tscn')
	var p:Player = p1.instantiate()
	p.client = client
	p.id = id
	p.deadCallback = playerDead
	root.add_child(p)
	if players.size() < id + 1:
		players.resize(id + 1)
	players[id] = p
	
	
func playerDead(id):
	players[id] = null
