extends Node

var menu:Menu
@export var confirm:Button
@export var back:Button
@export var portInput:LineEdit
@export var playerNumberInput:LineEdit

func _ready() -> void:
	confirm.pressed.connect(create)
	back.pressed.connect(backMenu)

func  backMenu():
	menu.switchTo('select')
	
func create():
	menu.createRoom(portInput.text,playerNumberInput.text)
