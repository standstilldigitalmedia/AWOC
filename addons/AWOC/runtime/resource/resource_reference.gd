@tool
class_name AWOCResourceReference
extends Resource

var uid: int
var path: String

func set_uid(new_uid: int) -> void:
	uid = new_uid

	
func set_path(new_path: String) -> void:
	path = new_path


func get_path() -> String:
	if Engine.is_editor_hint() and uid > 0:
		path = ResourceUID.get_id_path(uid)
	return path
	
	
func load_resource() -> Resource:
	get_path()
	if path.is_empty():
		return null
	return ResourceLoader.load(path)
