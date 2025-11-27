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
		var id_path = ResourceUID.get_id_path(uid)
		if not id_path.is_empty():
			return id_path
	return path


func update_path() -> void:
	if Engine.is_editor_hint() and uid > 0:
		var id_path = ResourceUID.get_id_path(uid)
		if not id_path.is_empty():
			path = id_path


func get_uid() -> int:
	return uid


func load_resource() -> Resource:
	var resource_path = get_path()
	if resource_path.is_empty():
		printerr("AWOCResourceReference: Path is empty (UID: ", uid, ")")
		return null
	if not FileAccess.file_exists(resource_path):
		printerr("AWOCResourceReference: File does not exist at path: ", resource_path)
		return null
	var ext = resource_path.get_extension().to_lower()
	if ext == "tscn" or ext == "scn":
		var scene = ResourceLoader.load(resource_path, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
		return scene
	var loaded = ResourceLoader.load(resource_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	return loaded
