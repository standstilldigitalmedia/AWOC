@tool
class_name AWOCEditorDiskResourceManager
extends AWOCEditorDictionaryResourceManager


func wait_for_scan() -> void:
	var filesystem = EditorInterface.get_resource_filesystem()
	if filesystem.is_scanning():
		await filesystem.filesystem_changed
		return
	filesystem.call_deferred("scan")
	await filesystem.filesystem_changed
	"""var filesystem = EditorInterface.get_resource_filesystem()
	if !filesystem:
		push_warning("EditorInterface.get_resource_filesystem() returned null")
		return
	var tree = Engine.get_main_loop() as SceneTree
	if !tree:
		push_warning("Could not get SceneTree")
		return
	if filesystem.is_scanning():
		var timeout = 10.0
		var start_time = Time.get_ticks_msec()
		while filesystem.is_scanning():
			await tree.process_frame
			if (Time.get_ticks_msec() - start_time) / 1000.0 > timeout:
				push_warning("Filesystem scan timeout after " + str(timeout) + " seconds")
				break
		await tree.process_frame
		return
	filesystem.scan()
	var timeout = 5.0 
	var start_time = Time.get_ticks_msec()
	while filesystem.is_scanning():
		await tree.process_frame
		if (Time.get_ticks_msec() - start_time) / 1000.0 > timeout:
			push_warning("Filesystem scan timeout after " + str(timeout) + " seconds")
			break
	await tree.process_frame"""
	
	
func save_resource(resource: Resource, path: String, bundle: bool = false) -> int:
	var save_result
	if bundle:
		save_result = ResourceSaver.save(resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	else:
		save_result = ResourceSaver.save(resource, path)
	if save_result != OK:
		return -1
	await wait_for_scan()
	var uid = ResourceLoader.get_resource_uid(path)
	if uid == ResourceUID.INVALID_ID:
		push_warning("Failed to get UID for path: " + path)
		return -1
	return uid
	
	
	
func create_dir_for_file_path(file_path: String) -> String:
	var base_path: String = file_path.get_base_dir()
	var dir = DirAccess.open(base_path)
	if !dir:
		dir = DirAccess.open("res://")
		var err = dir.make_dir_recursive(base_path)
		if err != OK:
			return "Could not create directory '" + base_path + "'. Code: " + str(err)
	return ""


func create_resource_on_disk(resource: Resource, res_name: String, path: String, extension = "tres") -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	if !AWOCValidator.is_valid_path_string(path):
		return "Invalid path for resource creation."
	var full_path: String = path + "/" + res_name + "." + extension
	var dir_created: String = create_dir_for_file_path(full_path)
	if !dir_created.is_empty():
		return dir_created
	var uid = await save_resource(resource,full_path) 
	if uid == ResourceUID.INVALID_ID:
		return "Failed to get UID for newly created resource: " + full_path
	return add_disk_resource_to_dictionary(res_name, uid)


func delete_resource_from_disk(res_name: String) -> String:
	var res_validated: String = validate_delete_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	if !parent_resource_dictionary.has(res_name):
		return "Resource not found in dictionary: " + res_name
	var resource_ref: AWOCResourceReference = parent_resource_dictionary[res_name]
	var file_path: String = resource_ref.get_ref_path()
	if file_path.is_empty():
		push_warning("Empty file path for resource: " + res_name)
		# Still try to remove from dictionary
		return delete_resource_from_dictionary(res_name)
	var extension = file_path.get_extension().to_lower()
	if extension == "gd" or extension == "tscn":
		parent_resource_dictionary.erase(res_name)
		save_parent_resource()
		var error_msg = "Attempted to delete source file (" + file_path + "). Removed dictionary reference only."
		push_error(error_msg)
		return error_msg
	if !FileAccess.file_exists(file_path):
		push_warning("File does not exist, removing from dictionary: " + file_path)
		return delete_resource_from_dictionary(res_name)
	var result: String = ""
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return "Failed to open directory for deletion"
	if AWOCEditorGlobal.SEND_TO_RECYCLE:
		var trash_result = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if trash_result != OK:
			result = "Failed to move file to trash: " + file_path + " (Error: " + str(trash_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_trash_result = OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
				if dir_trash_result != OK:
					push_warning("Failed to move empty directory to trash: " + base_dir + " (Error: " + str(dir_trash_result) + ")")
	else:
		var remove_result = dir.remove(file_path)
		if remove_result != OK:
			result = "Failed to remove file: " + file_path + " (Error: " + str(remove_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_remove_result = dir.remove(base_dir)
				if dir_remove_result != OK:
					push_warning("Failed to remove empty directory: " + base_dir + " (Error: " + str(dir_remove_result) + ")")
	if !result.is_empty():
		return result
	await wait_for_scan()
	return delete_resource_from_dictionary(res_name)


func rename_resource_on_disk(old_name: String, new_name: String) -> String:
	var res_validated: String = validate_rename_res(old_name, new_name)
	if !res_validated.is_empty():
		return res_validated
	var resource_ref: AWOCResourceReference = parent_resource_dictionary.get(old_name)
	if !resource_ref:
		return "Resource reference not found for " + old_name
	var resource_uid: int = resource_ref.get_uid()
	var old_path: String = ResourceUID.get_id_path(resource_uid)
	if old_path.is_empty() or !FileAccess.file_exists(old_path):
		return "Original file not found at " + old_path
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir() + "/" + new_name + "." + extension
	if FileAccess.file_exists(new_path):
		return "File already exists at destination: " + new_path
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return "Failed to open directory"
	var rename_result = dir.rename(old_path, new_path)
	if rename_result != OK:
		return "Failed to rename file from " + old_path + " to " + new_path + " (Error: " + str(rename_result) + ")"
	await wait_for_scan()
	resource_ref.set_ref_path(new_path)
	return rename_resource_in_dictionary(old_name, new_name)
