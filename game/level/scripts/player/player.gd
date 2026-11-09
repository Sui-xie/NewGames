extends CharacterBody2D
class_name Player

@export var speed: float = 200
@export var nameLabel:Label
@export var jumpCheckArea:JumpCheck
@export var mountPoint:Node2D
@export var targetPostion:Vector2 = Vector2(0,0)
@export var pickedCheckArea:Area2D

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
var meta = [ctx.tags.player]

func _enter_tree() -> void:
	if id != 0:
		set_multiplayer_authority(id)

func isClient():
	if ctx.onlineStatus == "offline":return true
	if multiplayer.get_unique_id() == id:return true
	return false

func _physics_process(delta: float) -> void:
	if not isClient():return
	setTargetPosition.rpc(position)
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y -= ctx.gravity*delta
	move_and_slide()

func _process(delta: float) -> void:
	if isClient():
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
		if(e.keycode == KEY_F):
			if e.pressed:
				if mountPoint.get_child_count() == 0:
					var n = queryCanPickedItem()
					if n == null:return
					pickedItem.rpc(n)
				else:
					thorwItem.rpc(velocity.angle(),false,velocity)
					
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

func queryCanPickedItem()->Item:
	var items = pickedCheckArea.get_overlapping_bodies()
	if items.is_empty():return null
	var current:Item
	for x in items:
		if not (x is Item):continue
		if ctx.tags.canPicked in x.meta:
			if current == null:
				current = x;
				continue
			if abs(self.position.x - x.position.x) < abs(self.position.x - current.position.x):
				current = x
	return current
	

func jump():
	if jumpCheckArea.jumpCheck():
		velocity.y = 0
		velocity.y += jumpForce
		jumpCheckArea.aJump()



@rpc("any_peer","call_remote","unreliable_ordered")
func setTargetPosition(vector:Vector2):
	targetPostion = vector

@rpc("authority","call_local","reliable")
func pickedItem(node:Item):
	if ctx.tags.canPicked in node.meta:
		node.freeze = true
		node.reparent(mountPoint,false)

#face值应该是一个弧度，表达丢出时角色的朝向
@rpc("authority","call_local","reliable")
func thorwItem(face:float,down:bool,velocity1:Vector2):
	var node = mountPoint.get_child(0)
	if node == null:return
	node.reparent(ctx.currentScene)
	if not down:
		node.freeze = false
		var s := velocity1
		s += Vector2.from_angle(face) * 50
		node.linear_velocity = s
		
