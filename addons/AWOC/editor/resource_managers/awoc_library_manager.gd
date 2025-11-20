@tool
class_name AWOCLibraryManager
extends AWOCEditorDiskResourceManager

@export var awoc_uid_dictionary: Dictionary = {}


func get_awoc_path(awoc_name: String) -> String:
	if !awoc_uid_dictionary.has(awoc_name):
		return ""
	return awoc_uid_dictionary.get(awoc_name).get_path()
	
	
func add_new_awoc(awoc_name: String, asset_path: String) -> AWOCResourceErrorMessage:
	var new_awoc: AWOCResource = AWOCResource.new()
	var awoc_created: String = create_resource_on_disk(new_awoc, awoc_name, asset_path)
	if !awoc_created.is_empty():
		return AWOCResourceErrorMessage.new(null, awoc_created)
	var parent_saved: String = save_parent_resource()
	if !parent_saved.is_empty():
		return AWOCResourceErrorMessage.new(new_awoc, parent_saved)
	return AWOCResourceErrorMessage.new(new_awoc, "")


func delete_awoc(awoc_name: String) -> String:
	var awoc_deleted: String = delete_resource_from_disk(awoc_name)
	if !awoc_deleted.is_empty():
		return awoc_deleted
	return save_parent_resource()


func rename_awoc(old_name: String, new_name: String) -> String:
	if !awoc_uid_dictionary.has(old_name):
		return "AWOC not found: " + old_name
	var resource_ref = awoc_uid_dictionary.get(old_name)
	if resource_ref == null:
		return "Invalid resource reference for: " + old_name
	var rename_message: String = rename_resource_on_disk(old_name, new_name, resource_ref.get_uid())
	if rename_message.is_empty():
		var save_parent: String = save_parent_resource()
		if !save_parent.is_empty():
			return save_parent
	return rename_message


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
		create_resource_on_disk(welcome_resource, "welcome", AWOCEditorGlobal.PLUGIN_PATH.path_join("begin_here"))
	var uid = ResourceLoader.get_resource_uid(full_file_path)
	welcome_resource.init_resource_manager(welcome_resource, uid, welcome_resource.awoc_uid_dictionary)
	return welcome_resource
