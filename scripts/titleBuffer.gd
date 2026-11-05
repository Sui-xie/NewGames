extends Label

var buffer: Array[Array] = [
		['欢迎来到我的神秘游戏！',1]
	]
var t:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ctx.on('addTitle',addText)
	print('[INFO]TextBuffer ready')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t-=delta
	if t <= 0:
		next()

func next() -> void:
	if(buffer.size() == 0):
		text = ''
		return
	var data = buffer.pop_front()
	if(data == null):return
	t = data[1]
	text = data[0]
	
#别问我为什么是text_string，问就是我看IDE有黄线不舒服	
func addText(text_string:String,d:float) -> void:
	if(buffer.size() >= 127):
		print('[WARN]TextBuffer overFlow')
		return
	buffer.append([text_string,d])
