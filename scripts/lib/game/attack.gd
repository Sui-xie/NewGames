extends Node
var bailu: PackedScene =  preload('res://scene/other/Bailu.tscn')
var waveInterval:float = 60
var nextWaveTime:float = 10
var t


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ctx.emit('addTitle',"敌人即将来袭",2)
	print("[INFO]AttackMgr ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	nextWaveTime-= delta
	if nextWaveTime < 0:
		spawn()

func spawn():
	ctx.emit('addTitle','敌人来袭！',1)
	nextWaveTime = waveInterval
	for i in 3:
		var b = bailu.instantiate()
		b.position = Vector2(randf() * 3000,randf() * 3000)
		add_child(b)