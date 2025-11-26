@tool
class_name AWOCLibraryManager
extends AWOCEditorDiskResourceManager


func create_resource(resource_name: String, additional_data: Dictionary) -> String:
	var new_awoc: AWOCResource = AWOCResource.new()
	print("DEBUG: Created new AWOCResource: ", new_awoc)
	print("DEBUG: slot_dictionary: ", new_awoc.slot_dictionary)
	print("DEBUG: mesh_dictionary: ", new_awoc.mesh_dictionary)

	var awoc_created: String = create_resource_on_disk(
		new_awoc, resource_name, additional_data.get("path")
	)
	print("DEBUG: create_resource_on_disk returned: ", awoc_created)

	if !awoc_created.is_empty():
		return awoc_created
	return ""


func rename_resource(old_name: String, new_name: String) -> String:
	return rename_resource_on_disk(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return delete_resource_from_disk(resource_name)


func get_awoc_path(awoc_name: String) -> String:
	if !has_named_resource(awoc_name):
		return ""
	return parent_resource_dictionary.get(awoc_name).get_path()


func get_awoc_uid(awoc_name: String) -> int:
	if !has_named_resource(awoc_name):
		return 0
	return parent_resource_dictionary.get(awoc_name).get_uid()


func load_welcome_resource_manager() -> AWOCLibraryManager:
	var welcome_resource: AWOCLibraryManager
	var full_file_path: String = AWOCEditorGlobal.plugin_path.path_join(
		AWOCEditorGlobal.WELCOME_BASE_PATH + AWOCEditorGlobal.WELCOME_FILE_NAME
	)
	if FileAccess.file_exists(full_file_path):
		welcome_resource = load(full_file_path) as AWOCLibraryManager
		if welcome_resource == null:
			printerr("Unable to load AWOCLibraryManager")
			return null
	else:
		welcome_resource = AWOCLibraryManager.new()
		var path_to_create = AWOCEditorGlobal.plugin_path.path_join(
			AWOCEditorGlobal.WELCOME_BASE_PATH
		)
		var creation_result = create_resource_on_disk(welcome_resource, "welcome", path_to_create)
		if !creation_result.is_empty():
			printerr(creation_result)
		AWOCEditorGlobal.request_scan.call_deferred()
	var uid = ResourceLoader.get_resource_uid(full_file_path)
	welcome_resource.init_resource_manager(
		welcome_resource, uid, welcome_resource.parent_resource_dictionary
	)
	return welcome_resource
