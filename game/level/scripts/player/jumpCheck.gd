extends Area2D
class_name JumpCheck

var jumpCooling = 0.1
var cooling = 0
@export var jumpNum = 1#多段跳
var jumpCount = 0#剩余跳跃次数
var isGround = false
var fristJump = true

func _ready() -> void:
	area_entered.connect(areaEnter)
	area_exited.connect(areaExit)
	body_entered.connect(areaEnter)
	body_exited.connect(areaExit)
	

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
			jumpCount = jumpNum
			fristJump = true
			
func aJump():
	#在空中首次跳跃扣除两次数，防止三段跳
	if jumpNum >= 2 and isGround == false and fristJump:
		jumpCount -= 2
		fristJump = false	
		return
	jumpCount-=1
	
func jumpCheck():
	if cooling != 0: return false
	if jumpCount == 0:return false
	if jumpNum <= 1 and isGround == false:return false
	return true