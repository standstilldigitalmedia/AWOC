@tool
class_name AWOCLibraryManager
extends AWOCEditorDiskResourceManager

func create_resource(resource_name: String, additional_data: Dictionary) -> void:
	var new_awoc: AWOCResource = AWOCResource.new()
	var awoc_created: String = create_resource_on_disk(new_awoc, resource_name, additional_data.get("asset_path"))
	if !awoc_created.is_empty():
		return AWOCResourceErrorMessage.new(null, awoc_created)
	return AWOCResourceErrorMessage.new(new_awoc, "")


func rename_resource(old_name: String, new_name: String) -> String:
	return rename_resource_on_disk(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return delete_resource_from_disk(resource_name)

	
func has_named_awoc(awoc_name: String) -> bool:
	return parent_resource_dictionary.has(awoc_name)
	
	
func get_awoc_path(awoc_name: String) -> String:
	if !has_named_awoc(awoc_name):
		return ""
	return parent_resource_dictionary.get(awoc_name).get_path()
	
	
func get_awoc_uid(awoc_name: String) -> int:
	if !has_named_awoc(awoc_name):
		return 0
	return parent_resource_dictionary.get(awoc_name).get_path()
	
	
func load_welcome_resource_manager() -> AWOCLibraryManager:
	var welcome_resource: AWOCLibraryManager
	var welcome_path: String = AWOCEditorGlobal.PLUGIN_PATH.path_join("begin_here")
	var full_file_path: String = welcome_path.path_join("welcome.res")
	if FileAccess.file_exists(full_file_path):
		welcome_resource = load(full_file_path) as AWOCLibraryManager
		if welcome_resource == null:
			printerr("Unable to load AWOCLibraryManager")
			return null
	else:
		welcome_resource = AWOCLibraryManager.new()
		var path_to_create = AWOCEditorGlobal.PLUGIN_PATH.path_join("begin_here")
		var creation_result = create_resource_on_disk(welcome_resource, "welcome", path_to_create)
		if !creation_result.is_empty():
			printerr("AWOC CRITICAL FAILURE: Could not create welcome.res. Reason: ", creation_result)
		create_resource_on_disk(welcome_resource, "welcome", AWOCEditorGlobal.PLUGIN_PATH.path_join("begin_here"))
		AWOCEditorGlobal.request_scan.call_deferred()
	var uid = ResourceLoader.get_resource_uid(full_file_path)
	welcome_resource.init_resource_manager(welcome_resource, uid, welcome_resource.awoc_uid_dictionary)
	return welcome_resource
