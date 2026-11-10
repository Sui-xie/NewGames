class_name SteelPipe;
extends Bullet

var t = 0;

func _init():
	speed = 3000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if team == 0:team = -1
	if rot == null:
		queue_free()
		return
	if shooter == null:
		print("[WARN]Shooter is Null")
		queue_free()
		return
	body_entered.connect(body_enter)
	area_entered.connect(body_enter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t+=delta*1000
	if t>3000 :
		queue_free()
		return
	self.position += Vector2.from_angle(rot) * speed * delta
	
func body_enter(target:Node) -> void:
	print("[INFO]子弹撞到了:",target.name)
	if "meta" in target:
		if ctx.tags.noEntry in target.meta:
			queue_free()
			return
	if target == shooter : return
	if not('team' in target):return
	if not('team' in shooter):return
	if target.team == shooter.team:return
	hit.rpc(target.get_path())
	return

@rpc("any_peer","call_local","reliable")
func hit(targetPath:String):
	var target = get_node(targetPath)
	print("[DEBUG]子弹命中了！:",target.name)
	queue_free()