@tool
class_name AWOCResourceReference
extends Resource

@export var uid: int
@export var path: String


func set_uid(new_uid: int) -> void:
	if new_uid <= 0:
		push_warning("Invalid UID: " + str(new_uid))
		return
	uid = new_uid


func set_path(new_path: String) -> void:
	if new_path.is_empty():
		push_warning("Empty path set for resource reference")
	path = new_path
	
	
func get_path() -> String:
	if Engine.is_editor_hint() and uid > 0:
		path = ResourceUID.get_id_path(uid)
	return path
	
	
func get_uid() -> int:
	return uid


func load_resource() -> Resource:
	get_path()
	if path.is_empty():
		return null
	return ResourceLoader.load(path)
