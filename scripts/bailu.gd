extends Area2D

var hp:int = 1000
var callBack:Callable
var player:CharacterBody2D
var speed:float = 150
var bullet: PackedScene = preload('res://scene/bullet.tscn')
var cooling:float = 0
var collingTime: float = 1.6
var team = 0

func _ready() -> void:
	if player == null:
		player = getPlayer()
	print(self.name)

func getPlayer():
	for i in ctx.players.size():
		if ctx.players[i] == null:
			continue
		return ctx.players[i]#为了以后实现复杂的索敌预留的

func _process(delta: float) -> void:
	ai(delta)
	if cooling != 0:
		cooling -= delta
		if cooling < 0:cooling = 0

func changeHp(health):
	hp-=health
	if hp < 0:
		exit()
		
func ai(delta:float):
	var deg := (self.global_position - player.global_position).angle() + deg_to_rad(180)
	self.position += Vector2.from_angle(deg) * speed * delta
	shoot()
	

func exit() -> void:
	if callBack.is_valid():
		callBack.call()
	queue_free()
	return

func shoot() -> void:
	if cooling != 0:return
	var b:Buttlt = bullet.instantiate()
	b.shooter = self
	var r := (player.global_position - global_position).angle() 
	b.rot = r
	b.rotation = r - deg_to_rad(-25)#偏二十五度，因为我懒得去修图
	b.damage = 10
	add_child(b)
	b.global_position = self.global_position
	cooling = collingTime
