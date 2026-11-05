extends CanvasLayer

var titleBuffer:TitleBuffer

func _ready() -> void:
	titleBuffer = get_node('/title')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func title(text,delay):
	titleBuffer.addText(text,delay)