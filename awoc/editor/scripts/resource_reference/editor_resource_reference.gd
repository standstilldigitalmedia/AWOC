@tool
class_name AWOCEditorResourceReference
extends Resource

var _reference: AWOCResourceReference

func _init(reference: AWOCResourceReference) -> void:
	_reference = reference
	
	
func load_res() -> AWOCResourceBase:
	update_res_path()
	if FileAccess.file_exists(_reference.path):
		if _reference._resource == null:
			_reference._resource = load(_reference.path)
		return _reference._resource
	return null
	
	
func delete_res() -> bool:
	if !Engine.is_editor_hint():
		return false
	var full_path: String = get_res_path()
	var base_dir: String = full_path.get_base_dir()
	var dir_access: DirAccess = DirAccess.open(base_dir)
	if !dir_access:
		return false
	if AWOCGlobal.SEND_TO_RECYCLE:
		OS.move_to_trash(ProjectSettings.globalize_path(full_path))
		if (
				dir_access.get_files_at(base_dir).size() < 1 
				and dir_access.get_directories_at(base_dir).size() < 1
			):
				OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
	else:
		dir_access.remove(full_path)
		if (
				dir_access.get_files_at(base_dir).size() < 1 
				and dir_access.get_directories_at(base_dir).size() < 1
			):
				dir_access.remove(base_dir)
	_reference._resource = null
	return true
	
	
func rename_res(new_name: String) -> bool:
	if !Engine.is_editor_hint():
		return false
	var old_path: String = get_res_path()
	if old_path.length() < 6:
		printerr("Path to rename :" + old_path + ", must be at least 6 characters.")
		return false
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(_reference.uid, new_path)
	_reference.path = new_path
	return true
	

func save_res() -> bool:
	if !Engine.is_editor_hint():
		return false
	var base_directory = get_res_path().get_base_dir()	
	var dir = DirAccess.open(base_directory)
	if !dir:
		dir = DirAccess.open("res://")
		dir.make_dir_recursive(base_directory)
	ResourceSaver.save(_reference._resource, _reference.path)
	if _reference.uid < 1:
		_reference.uid = ResourceLoader.get_resource_uid(_reference.path)
	return true

	
func set_res(resource) -> void:
	if !Engine.is_editor_hint():
		return
	_reference._resource = resource
	
	
func set_res_path(new_path: String) -> void:
	if !Engine.is_editor_hint():
		return
	_reference.path = new_path
	

func set_res_uid(new_uid: int) -> void:
	if !Engine.is_editor_hint():
		return
	_reference.uid = new_uid
	
			
func update_res_path() -> void:
	if !Engine.is_editor_hint():
		return
	if _reference.uid > 1:
		_reference.path = ResourceUID.get_id_path(_reference.uid)
		
		
func get_res_path() -> String:
	update_res_path()
	return _reference.path
