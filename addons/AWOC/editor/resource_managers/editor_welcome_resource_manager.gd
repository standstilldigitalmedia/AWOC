@tool
class_name AWOCEditorWelcomeResourceManager
extends AWOCEditorDiskResourceManager

@export var awoc_uid_dictionary: Dictionary

func get_dictionary() -> Dictionary:
	return awoc_uid_dictionary
	
							
func add_awoc(awoc_name: String, asset_path: String) -> void:
	var base_path: String = asset_path.get_base_dir()
	if create_resource_on_disk(AWOCResource.new(), awoc_name, asset_path):
		save_parent_resource()
		AWOCGlobal.scan()
	
	
func delete_awoc(awoc_name: String) -> void:
	if delete_resource_from_disk(awoc_name):
		save_parent_resource()
		AWOCGlobal.scan()
	
	
func rename_awoc(old_name: String, new_name: String) -> void:
	if rename_resource_on_disk(old_name, new_name, awoc_uid_dictionary[old_name]):
		save_parent_resource()
		AWOCGlobal.scan()
	
		
func load_welcome_resource_manager() -> AWOCEditorWelcomeResourceManager:
	var welcome_resource: AWOCEditorWelcomeResourceManager
	if FileAccess.file_exists(AWOCGlobal.WELCOME_RESOURCE_PATH):
		welcome_resource =  load(AWOCGlobal.WELCOME_RESOURCE_PATH)
	else:
		welcome_resource = AWOCEditorWelcomeResourceManager.new()
		create_resource_on_disk(welcome_resource, "welcome", AWOCGlobal.WELCOME_RESOURCE_PATH.get_base_dir())
		AWOCGlobal.scan()
	welcome_resource.init_resource_manager(welcome_resource, ResourceLoader.get_resource_uid(AWOCGlobal.WELCOME_RESOURCE_PATH),welcome_resource.awoc_uid_dictionary)
	return welcome_resource
