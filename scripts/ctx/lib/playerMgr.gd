extends Node
class_name PlayerMgr

var ctx:Ctx;
var player = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addPlayer(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addPlayer(id):
	var p1 = load('res://scritps/player/player.gd')
	var p:PlayerMgr = p1.instance()
	p.client = true
	p.id = id
	p.deadCallback(playerDead)
	ctx.root.add_child(p)
	player[id] = p
	
func playerDead(id):
	player[id] = null