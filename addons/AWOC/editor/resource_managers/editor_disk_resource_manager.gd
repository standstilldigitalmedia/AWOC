@tool
class_name AWOCEditorDiskResourceManager
extends AWOCEditorDictionaryResourceManager


func create_dir_for_file_path(file_path: String) -> String:
	var base_path: String = file_path.get_base_dir()
	var dir = DirAccess.open(base_path)
	if !dir:
		dir = DirAccess.open("res://")
		var err = dir.make_dir_recursive(base_path)
		if err != OK:
			return "Could not create directory '" + base_path + "'. Code: " + str(err)
	return ""
			
			
func save_skeleton_to_disk(skeleton_node: Skeleton3D, save_path: String) -> String:
	var new_skeleton = skeleton_node.duplicate()
	new_skeleton.position = Vector3.ZERO
	new_skeleton.rotation = Vector3.ZERO
	new_skeleton.scale = Vector3.ONE
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(new_skeleton)
	if result != OK:
		new_skeleton.queue_free()
		return "Error: Could not pack skeleton scene."
	var dir_created: String = create_dir_for_file_path(save_path)
	if !dir_created.is_empty():
		return dir_created
	var save_result = ResourceSaver.save(packed_scene, save_path)
	new_skeleton.queue_free()
	if save_result != OK:
		return "Error saving skeleton file."
	var uid = ResourceLoader.get_resource_uid(save_path)
	var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	resource_reference.set_uid(uid)
	AWOCState.current_awoc.skeleton_reference = resource_reference
	return save_parent_resource()
	
	
func create_resource_on_disk(resource: Resource, res_name: String, path: String, extension="tres") -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	if !AWOCValidator.is_valid_path_string(path):
		return "Invalid path for resource creation."
	var full_path: String = path + "/" + res_name + "." + extension
	var dir_created: String = create_dir_for_file_path(full_path)
	if !dir_created.is_empty():
		return dir_created
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
	var extension = file_path.get_extension().to_lower()
	if extension == "gd" or extension == "tscn":
		parent_resource_dictionary.erase(res_name)
		save_parent_resource()
		var error_msg = "Attempted to delete source file (" + file_path + "). Removed dictionary reference only."
		push_error(error_msg)
		return error_msg
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


func rename_resource_on_disk(old_name: String, new_name: String) -> String:
	var res_validated: String = validate_rename_res(old_name, new_name)
	if !res_validated.is_empty():
		return res_validated
	var resource_ref: AWOCResourceReference = parent_resource_dictionary.get(old_name)
	var resource_uid: int = resource_ref.get_uid()
	var old_path: String = ResourceUID.get_id_path(resource_uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(resource_uid, new_path)
	return rename_resource_in_dictionary(old_name, new_name)
