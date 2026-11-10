extends Area2D
class_name Bullet

var shooter:Weapon
var team:int
var rot:float
var speed:float

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

@rpc("any_peer","call_local","reliable")
func hit(target:String):
	print("[WARN]未被重写的hit方法")