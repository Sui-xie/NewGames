extends Sprite2D

var aim_angle: float = 0.0

func _process(_delta: float) -> void:
	flip_v = absf(global_rotation) > PI / 2.0
