@tool
class_name AWOCEditorAWOCResourceManager
extends AWOCEditorDiskResourceManager

@export var awoc_uid_dictionary: Dictionary

func get_dictionary() -> Dictionary:
	return awoc_uid_dictionary
	
							
func add_new_awoc(awoc_name: String, asset_path: String) -> AWOCResource:
	var base_path: String = asset_path.get_base_dir()
	var new_awoc: AWOCResource = AWOCResource.new()
	if create_resource_on_disk(new_awoc, awoc_name, asset_path):
		save_parent_resource()
		AWOCEditorGlobal.scan()
	return null
	
	
func delete_awoc(awoc_name: String) -> void:
	if delete_resource_from_disk(awoc_name):
		save_parent_resource()
		AWOCEditorGlobal.scan()
	
	
func rename_awoc(old_name: String, new_name: String) -> void:
	if rename_resource_on_disk(old_name, new_name, awoc_uid_dictionary[old_name]):
		save_parent_resource()
		AWOCEditorGlobal.scan()
	
		
func load_welcome_resource_manager() -> AWOCEditorAWOCResourceManager:
	var welcome_resource: AWOCEditorAWOCResourceManager
	if FileAccess.file_exists(AWOCEditorGlobal.WELCOME_RESOURCE_PATH):
		welcome_resource =  load(AWOCEditorGlobal.WELCOME_RESOURCE_PATH)
	else:
		welcome_resource = AWOCEditorAWOCResourceManager.new()
		create_resource_on_disk(welcome_resource, "welcome", AWOCEditorGlobal.WELCOME_RESOURCE_PATH.get_base_dir())
		AWOCEditorGlobal.scan()
	welcome_resource.init_resource_manager(welcome_resource, ResourceLoader.get_resource_uid(AWOCEditorGlobal.WELCOME_RESOURCE_PATH),welcome_resource.awoc_uid_dictionary)
	return welcome_resource
