extends MapBlock
class_name BasicBlock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meta.append(ctx.tags.ground)
	meta.append(ctx.tags.mapWall)
	meta.append(ctx.tags.noEntry)