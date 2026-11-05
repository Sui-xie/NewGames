extends Node
class_name EventBus

var _listeners := {}        
var _id_to_event := {}  
var _next_id := 0
var _id_pool := []      

func on(event: String, callback: Callable) -> int:
	if not _listeners.has(event):
		_listeners[event] = []

	var id: int
	if _id_pool.size() > 0:
		id = _id_pool.pop_back()
	else:
		id = _next_id
		_next_id += 1

	_listeners[event].append({ "id": id, "callback": callback })
	_id_to_event[id] = event
	return id

func off(id: int) -> bool:
	if not _id_to_event.has(id):
		return false

	var event: String = _id_to_event[id]
	_id_to_event.erase(id)

	var list: Array = _listeners.get(event, [])
	for i in range(list.size()):
		if list[i].id == id:
			list.remove_at(i)
			break

	if list.is_empty():
		_listeners.erase(event)

	_id_pool.append(id)
	return true

func emit(event: String, ...args) -> void:
	if not _listeners.has(event):
		return
	
	var snapshot: Array = _listeners[event].duplicate()
	for entry in snapshot:
		if not _id_to_event.has(entry.id):
			continue
		entry.callback.callv(args)