extends Node

var menu:Menu
@export var confirm:Button
@export var back:Button
@export var portInput:LineEdit
@export var ipInput:LineEdit

func _ready() -> void:
	confirm.pressed.connect(join)
	back.pressed.connect(backMenu)

func  backMenu():
	menu.switchTo('select')
	
func join():
	menu.joinRoom(ipInput.text,portInput.text)
