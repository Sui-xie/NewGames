extends CanvasLayer

@export var titleBuffer:TitleBuffer

func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func title(text,delay):
	titleBuffer.addText(text,delay)