extends CharacterBody2D
class_name PlayerTest

@export var speed: float = 200
@export var nameLabel:Label
@export var healthBar:ProgressBar
@export var jumpCheckArea:JumpCheckTest
var jumpForce:float = -1000
var cam:Camera2D
var zoom: Vector2 = Vector2(1,1)
var zoomSpeed: float = 0.05
var maxZoom: Vector2 = Vector2(4,4)
var minZoom: Vector2 = Vector2(0.1,0.1)
var bullet: PackedScene = preload('res://test/bullet.tscn')
var cooling = 0
var collingTime = 0.3
var hp:float = 1000
var maxHp:float = 1000
var team:int = 1
var id = 0;
@export var targetPositon:Vector2 = Vector2(0,0);


func _enter_tree() -> void:
	if id == 0 and name.begins_with("player"):
		id = int(name.trim_prefix("player"))
	if id != 0:
		set_multiplayer_authority(id)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():return
	#print("我是权威，id=", id, " authority=", get_multiplayer_authority(), " name=", name)
	var direction = 0
	direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y -= ctx.gravity*delta
	move_and_slide()
	targetPositon = position

func _process(delta: float) -> void:
	nameLabel.text = "玩家:%d" % id
	healthBar.value = (hp / maxHp) * 100
	if cooling != 0:
		cooling -= delta
		if cooling < 0:cooling = 0
	if not is_multiplayer_authority():
		position = position.lerp(targetPositon,10.0 * delta)
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):shoot()
	
func _input(e):
	if not is_multiplayer_authority():return
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
	if is_multiplayer_authority():
		cam = Camera2D.new()
		add_child(cam)
		cam.zoom = zoom


func shoot():
	if cooling != 0:return
	var b:ButtltTest = bullet.instantiate()
	b.shooter = self
	var r := (get_global_mouse_position() - global_position).angle() 
	b.rot = r
	b.rotation = r - deg_to_rad(-25)#偏二十五度，因为我懒得去修图
	b.damage = 100
	ctx.currentScene.add_child(b)
	b.global_position = self.global_position
	cooling = collingTime

func change_zoom(z):
	var new: Vector2 = zoom + Vector2(z,z)
	if new > maxZoom:new = maxZoom
	if new < minZoom:new = minZoom
	zoom = new
	cam.zoom = new

func changeHp(health):
	hp-=health
	if hp < 0:
		dead()

func dead() -> void:
	queue_free()

func jump():
	if jumpCheckArea.jumpCheck():
		velocity.y = 0
		velocity.y += jumpForce
		jumpCheckArea.aJump()
