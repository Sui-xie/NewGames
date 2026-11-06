extends Area2D
class_name JumpCheck

var jumpCooling = 0.1
var cooling = 0
@export var jumpNum = 1#多段跳
var jumpCount = 0#剩余跳跃次数
var isGround = false

func _ready() -> void:
	area_entered.connect(areaEnter)
	body_entered.connect(areaEnter)
	

func _process(delta: float) -> void:
	if cooling > 0:
		cooling-=delta
		if cooling < 0:
			cooling = 0

func areaExit(node):
	#print("[INFO]玩家接触物体")
	if "meta" in node:
		#print("[INFO]物体含有meta")
		if "ground" in node.meta:
			isGround = false
			#print("[INFO]物体含有ground")

func areaEnter(node):
	#print("[INFO]玩家接触物体")
	if "meta" in node:
		#print("[INFO]物体含有meta")
		if "ground" in node.meta:
			isGround = true
			#print("[INFO]物体含有ground")
			resetJumpCount()
	
func aJump():
	jumpCount-=1
	isGround = false
	
func jumpCheck():
	if cooling != 0: return false
	if jumpCount == 0:return false
	if jumpNum <= 1 and isGround:return false
	return true
	
	
func resetJumpCount():
	jumpCount = jumpNum