extends Node

var meta = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meta.append(ctx.tags.canPicked)
