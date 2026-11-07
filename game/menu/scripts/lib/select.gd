extends Node

var menu:Menu
@export var createButton:Button
@export var joinButton:Button
@export var singalePlay:Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createButton.pressed.connect(create)
	joinButton.pressed.connect(join)
	singalePlay.pressed.connect(play)

func  join():
	menu.switchTo('join')
	
func create():
	menu.switchTo('create')
	
func play():
	menu.play()
