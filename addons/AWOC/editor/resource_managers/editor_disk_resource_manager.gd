@tool
class_name AWOCEditorDiskResourceManager
extends AWOCEditorDictionaryResourceManager


func create_resource_on_disk(resource: Resource, res_name: String, path: String) -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	if !AWOCValidator.is_valid_directory_path(path):
		return "Invalid path for resource creation."
	var dir = DirAccess.open(path)
	if !dir:
		dir = DirAccess.open("res://")
		dir.make_dir_recursive(path)
	var full_path: String = path + "/" + res_name + ".res"
	ResourceSaver.save(resource, full_path)
	var uid = ResourceLoader.get_resource_uid(full_path)
	if uid == ResourceUID.INVALID_ID:
		return "Failed to get UID for newly created resource: " + full_path
	return add_disk_resource_to_dictionary(res_name, ResourceLoader.get_resource_uid(full_path))


func delete_resource_from_disk(res_name: String) -> String:
	var res_validated: String = validate_delete_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	if !parent_resource_dictionary.has(res_name):
		return "Resource not found in dictionary: " + res_name
	var file_path: String = parent_resource_dictionary[res_name].get_path()
	if !FileAccess.file_exists(file_path):
		return "File does not exist: " + file_path
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open("res://")
	if AWOCEditorGlobal.SEND_TO_RECYCLE:
		var trash_result = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if trash_result != OK:
			return "Failed to move file to trash: " + file_path + " (Error: " + str(trash_result) + ")"
		if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
			var dir_trash_result = OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
			if dir_trash_result != OK:
				push_warning("Failed to move empty directory to trash: " + base_dir + " (Error: " + str(dir_trash_result) + ")")
	else:
		var remove_result = dir.remove(file_path)
		if remove_result != OK:
			return "Failed to remove file: " + file_path + " (Error: " + str(remove_result) + ")"
		if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
			var dir_remove_result = dir.remove(base_dir)
			if dir_remove_result != OK:
				push_warning("Failed to remove empty directory: " + base_dir + " (Error: " + str(dir_remove_result) + ")")
	return delete_resource_from_dictionary(res_name)


func rename_resource_on_disk(old_name: String, new_name: String, uid: int) -> String:
	var res_validated: String = validate_rename_res(old_name, new_name)
	if !res_validated.is_empty():
		return res_validated
	var old_path: String = ResourceUID.get_id_path(uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(uid, new_path)
	return rename_resource_in_dictionary(old_name, new_name)
