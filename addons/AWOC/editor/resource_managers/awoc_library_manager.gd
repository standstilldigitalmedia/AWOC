@tool
class_name AWOCLibraryManager
extends AWOCEditorDiskResourceManager

func create_resource(resource_name: String, additional_data: Dictionary) -> String:
	var new_awoc: AWOCResource = AWOCResource.new()
	var awoc_created: String = await create_resource_on_disk(new_awoc, resource_name, additional_data.get("path"))
	if !awoc_created.is_empty():
		return awoc_created
	return ""


func rename_resource(old_name: String, new_name: String) -> String:
	return await rename_resource_on_disk(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return await delete_resource_from_disk(resource_name)


func get_awoc_path(awoc_name: String) -> String:
	if !has_named_resource(awoc_name):
		return ""
	return parent_resource_dictionary.get(awoc_name).get_path()


func get_awoc_uid(awoc_name: String) -> int:
	if !has_named_resource(awoc_name):
		return 0
	return parent_resource_dictionary.get(awoc_name).get_uid()


func load_welcome_resource_manager() -> AWOCLibrary:
	var welcome_resource: AWOCLibrary
	var full_file_path: String = AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.WELCOME_BASE_PATH + AWOCEditorGlobal.WELCOME_FILE_NAME)

	if FileAccess.file_exists(full_file_path):
		welcome_resource = ResourceLoader.load(full_file_path, "", ResourceLoader.CACHE_MODE_IGNORE) as AWOCLibrary
		if welcome_resource == null:
			push_error("Unable to load AWOCLibrary from: " + full_file_path)
			return null
		# Ensure the dictionary is initialized
		if welcome_resource.awoc_resource_reference_dictionary == null:
			var typed_dict: Dictionary[String, AWOCResourceReference] = {}
			welcome_resource.awoc_resource_reference_dictionary = typed_dict
	else:
		# Welcome file doesn't exist, create it
		welcome_resource = AWOCLibrary.new()
		# Initialize the dictionary if it's null
		if welcome_resource.awoc_resource_reference_dictionary == null:
			var typed_dict: Dictionary[String, AWOCResourceReference] = {}
			welcome_resource.awoc_resource_reference_dictionary = typed_dict

		var path_to_create = AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.WELCOME_BASE_PATH)
		# Ensure directory exists
		if !DirAccess.dir_exists_absolute(path_to_create):
			var dir_result = DirAccess.make_dir_recursive_absolute(path_to_create)
			if dir_result != OK:
				push_error("Failed to create directory: " + path_to_create)
				return null

		# Save the file - this will wait for any ongoing scan
		var uid: int = await save_resource(welcome_resource, full_file_path)
		if uid < 1:
			push_error("AWOCLibrary could not be saved to: " + full_file_path)
			return null

	return welcome_resource


func init_library_manager() -> void:
	parent_resource = await load_welcome_resource_manager()
	if !parent_resource:
		push_error("Failed to initialize library manager: welcome resource is null")
		var typed_dict: Dictionary[String, AWOCResourceReference] = {}
		parent_resource_dictionary = typed_dict
		return

	var full_file_path: String = AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.WELCOME_BASE_PATH + AWOCEditorGlobal.WELCOME_FILE_NAME)
	parent_uid = ResourceLoader.get_resource_uid(full_file_path)

	if parent_uid == ResourceUID.INVALID_ID:
		push_warning("Welcome resource has invalid UID")

	parent_resource_dictionary = parent_resource.awoc_resource_reference_dictionary
	if !parent_resource_dictionary:
		push_warning("Welcome resource dictionary is null, initializing to empty")
		var typed_dict: Dictionary[String, AWOCResourceReference] = {}
		parent_resource_dictionary = typed_dict
		parent_resource.awoc_resource_reference_dictionary = typed_dict
	
