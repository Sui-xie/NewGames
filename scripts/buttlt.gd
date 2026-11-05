class_name Buttlt;
extends Area2D

var t = 0;
var speed = 3000;
var rot:float = 0;
var shooter;
var damage;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
func body_enter(b:Node) -> void:
	if b == shooter : return
	if not('team' in b):return
	if not('team' in shooter):return
	if b.team == shooter.team:return
	if b.has_method('changeHp'):
		print("扣血:",damage,"剩余:",b.hp)
		b.changeHp(damage)
	else:
		print("[WARN]Not found Method: changeHp,Node Name is:",b.name)
		return
	queue_free()
	return
