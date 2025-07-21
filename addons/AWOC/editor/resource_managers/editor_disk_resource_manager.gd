@tool
class_name AWOCEditorDiskResourceManager
extends AWOCEditorResourceManagerBase


func add_disk_resource_to_dictionary(res_name: String, uid: int) -> bool:
	if validate_new_res(res_name):
		resource_dictionary[res_name] = uid
		return true
	return false
	

func add_resource(res_name: String, resource: Resource, path: String = "") -> bool:
	if !validate_new_res(res_name):
		return false
	if !AWOCGlobal.is_valid_path(path):
		push_error("Invalid path for resource creation.")
		return false
	var dir = DirAccess.open(path)
	if !dir:
		dir = DirAccess.open("res://")
		dir.make_dir_recursive(path)
	var full_path: String = path + "/" + res_name + ".res"
	ResourceSaver.save(resource, full_path)
	AWOCGlobal.scan()
	return add_disk_resource_to_dictionary(res_name, ResourceLoader.get_resource_uid(full_path))
		

func delete_resource(res_name: String) -> bool:
	var file_path: String = ResourceUID.get_id_path(resource_dictionary[res_name])
	if !validate_delete_res(res_name):
		return false
	if !FileAccess.file_exists(file_path):
		return false
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open("res://")
	if AWOCGlobal.SEND_TO_RECYCLE:
		OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
			OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
	else:
		dir.remove(file_path)
		if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
			dir.remove(base_dir)
	AWOCGlobal.scan()
	return super(res_name)
	
				
func rename_resource(old_name: String, new_name: String, uid: int = 0) -> bool:
	if !validate_rename_res(old_name, new_name):
		return false
	var old_path: String = ResourceUID.get_id_path(uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(uid, new_path)
	AWOCGlobal.scan()
	return super(old_name, new_name)
