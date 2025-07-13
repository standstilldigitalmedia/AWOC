@tool
class_name AWOCEditorWelcomeResourceManager
extends AWOCEditorDiskResourceManager

@export var awoc_uid_dictionary: Dictionary


func rename_awoc(old_name: String, new_name: String) -> void:
	rename_resource(old_name, new_name, awoc_uid_dictionary[old_name])
	
		
func load_welcome_resource_manager() -> AWOCEditorWelcomeResourceManager:
	var welcome_resource: AWOCEditorWelcomeResourceManager
	if FileAccess.file_exists(AWOCGlobal.WELCOME_RESOURCE_PATH):
		welcome_resource =  load(AWOCGlobal.WELCOME_RESOURCE_PATH)
	else:
		welcome_resource = AWOCEditorWelcomeResourceManager.new()
		add_resource("welcome", welcome_resource, AWOCGlobal.WELCOME_RESOURCE_PATH.get_base_dir())
		AWOCGlobal.scan()
	welcome_resource.init_resource_manager(welcome_resource, ResourceLoader.get_resource_uid(AWOCGlobal.WELCOME_RESOURCE_PATH),welcome_resource.awoc_uid_dictionary)
	return welcome_resource
