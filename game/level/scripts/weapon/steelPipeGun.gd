extends Weapon
@export var shootPoint:Node2D
@export var bullet:PackedScene

var cooling = 0
var collingTime = 0.3
var team:int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meta.append(ctx.tags.canPicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooling != 0:
		cooling -= delta
		if cooling < 0:cooling = 0

func active():
	if cooling == 0:
		shoot.rpc(get_global_mouse_position(),self.global_position)

#显式输入位置防止延迟偏移
@rpc("any_peer","call_local","reliable")
func shoot(mousePosition:Vector2,shooterPosition:Vector2):
	var b = bullet.instantiate()
	b.shooter = self
	var r := (mousePosition - shooterPosition).angle()
	b.rotation = r 
	b.rot = r
	ctx.currentScene.add_child(b)
	b.global_position = shooterPosition
	cooling = collingTime
	#print("[INFO]报告，来自玩家:",ctx.clientId,"的执行")

@rpc("any_peer","call_local","reliable")
func reload():
	print("[INFO]这把枪不需要换弹")
