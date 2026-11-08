extends CharacterBody2D
class_name Player

@export var speed: float = 200
@export var nameLabel:Label
@export var jumpCheckArea:JumpCheck
@export var targetPostion:Vector2 = Vector2(0,0)

var jumpForce:float = -1000
var cam:Camera2D
var zoom: Vector2 = Vector2(1,1)
var zoomSpeed: float = 0.05
var maxZoom: Vector2 = Vector2(4,4)
var minZoom: Vector2 = Vector2(0.1,0.1)
var bullet: PackedScene = preload('res://game/level/scene/bullet.tscn')
var cooling = 0
var collingTime = 0.3
var team:int = 1
var id: int = 0;
var uuid: int = 0xffffff00;
var nickName:String = "玩家";


func _enter_tree() -> void:
	if id != 0:
		set_multiplayer_authority(id)

func isClient():
	if ctx.onlineStatus == "offline":return true
	if multiplayer.get_unique_id() == id:return true
	return false

func _physics_process(delta: float) -> void:
	if not isClient():return
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y -= ctx.gravity*delta
	move_and_slide()

func _process(delta: float) -> void:
	if isClient():
		setTargetPosition.rpc(position)
		nameLabel.text = nickName + ":%d" % id
		if cooling != 0:
			cooling -= delta
			if cooling < 0:cooling = 0
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if cooling != 0:return
			shoot.rpc(get_global_mouse_position(),self.global_position)
	else:
		position = position.lerp(targetPostion,1)
		return
	
func _input(e):
	if not isClient():return
	if(e is InputEventKey):
		if(e.keycode == KEY_SPACE):
			if e.pressed:
				jump()
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(zoomSpeed)
		if e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(-zoomSpeed)
	
func _ready() -> void:
	if isClient():
		cam = Camera2D.new()
		add_child(cam)
		cam.make_current()
		cam.zoom = zoom
	if isClient():
		ctx.clientId = id

#显式输入位置防止延迟偏移
@rpc("any_peer","call_local","reliable")
func shoot(mousePosition:Vector2,playerPosition:Vector2):
	var b:Buttlt = bullet.instantiate()
	b.shooter = self
	var r := (mousePosition - playerPosition).angle() 
	b.rot = r
	b.rotation = r - deg_to_rad(-25)#偏二十五度，因为我懒得去修图
	ctx.currentScene.add_child(b)
	b.global_position = playerPosition
	cooling = collingTime
	#print("[INFO]报告，来自玩家:",ctx.clientId,"的执行")

func change_zoom(z):
	var new: Vector2 = zoom + Vector2(z,z)
	if new > maxZoom:new = maxZoom
	if new < minZoom:new = minZoom
	zoom = new
	cam.zoom = new

func jump():
	if jumpCheckArea.jumpCheck():
		velocity.y = 0
		velocity.y += jumpForce
		jumpCheckArea.aJump()

@rpc("any_peer","call_remote","unreliable")
func setTargetPosition(vector:Vector2):
	targetPostion = vector
