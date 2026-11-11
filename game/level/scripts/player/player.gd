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
var team:int = 1
var id: int = 0;
var uuid: int = 0xffffff00;
var nickName:String = "玩家";
var meta = [ctx.tags.player]
var mousePosition:Vector2

func _enter_tree() -> void:
	if id != 0:
		set_multiplayer_authority(id)

func isClient():
	if ctx.onlineStatus == "offline":return true
	if multiplayer.get_unique_id() == id:return true
	return false

func _physics_process(delta: float) -> void:
	if not isClient():return
	sync.rpc(position,get_global_mouse_position())
	calcMountPosition()
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y -= ctx.gravity*delta
	move_and_slide()

func _process(_delta: float) -> void:
	nameLabel.text = nickName + ":%d" % id
	if isClient():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			use()
	else:
		calcMountPosition(mousePosition)
		position = position.lerp(targetPostion,1)
		return

func calcMountPosition(globalMousePosition:Vector2 = Vector2.ZERO):
	if globalMousePosition == Vector2.ZERO:
		globalMousePosition = get_global_mouse_position()
	var r: float = (globalMousePosition - global_position).angle()
	var p:Vector2 = Vector2.from_angle(r) * 100
	mountPoint.position = p
	mountPoint.rotation = r
	
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
					pickedItem.rpc(n.get_path())
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

func change_zoom(z):
	var new: Vector2 = zoom + Vector2(z,z)
	if new > maxZoom:new = maxZoom
	if new < minZoom:new = minZoom
	zoom = new
	cam.zoom = new

func queryCanPickedItem()->Item:
	var items = pickedCheckArea.get_overlapping_bodies()
	if items.is_empty():return null
	var current:Item = null
	for x in items:
		if not (x is Item):continue
		if ctx.tags.canPicked in x.meta:
			if current == null:
				current = x;
				continue
			if abs(self.position.x - x.position.x) < abs(self.position.x - current.position.x):
				current = x
	return current
	
func use() -> void:
	if mountPoint.get_child_count() == 0:return
	if mountPoint.get_child(0) is Weapon:
		var i:Weapon = mountPoint.get_child(0)
		i.active()
		return

func jump():
	if jumpCheckArea.jumpCheck():
		velocity.y = 0
		velocity.y += jumpForce
		jumpCheckArea.aJump()

@rpc("authority","call_remote","unreliable_ordered")
func sync(targetPos:Vector2,mousePos:Vector2):
	targetPostion = targetPos
	mousePosition = mousePos

@rpc("authority","call_local","reliable")
func pickedItem(nodePath:String):
	var node:Item = get_node(nodePath)
	if ctx.tags.canPicked in node.meta:
		node.freeze = true
		node.global_position = mountPoint.global_position
		node.rotation = mountPoint.rotation
		node.reparent(mountPoint)

#face值应该是一个弧度，表达丢出时角色的朝向
@rpc("authority","call_local","reliable")
func thorwItem(face:float,down:bool,velocity1:Vector2):
	var node = mountPoint.get_child(0)
	if node == null:
		print("我是玩家:",ctx.clientId,"，无法找到挂载点！")
	if node == null:return
	node.reparent(ctx.getService("itemMgr"))
	if not down:
		node.freeze = false
		var s := velocity1
		s += Vector2.from_angle(face) * 50
		node.linear_velocity = s

@rpc("any_peer","call_local","reliable")
func dropItem():
	if mountPoint.get_child_count() == 0:return
	var target:Item =mountPoint.get_child(0)
	target.freeze = false
	target.reparent(ctx.getService("itemMgr"))
