extends Item
class_name Weapon 

@rpc("any_peer","call_local","reliable")
func shoot(targetPosition,shooterPosition):
	print("[WARN]未被重写的Shoot方法")
	
@rpc("any_peer","call_local","reliable")
func reload():	
	print("[WARN]未被重写的Reload方法")
	
func active():
	print("[WARN]未被重写的Active方法")