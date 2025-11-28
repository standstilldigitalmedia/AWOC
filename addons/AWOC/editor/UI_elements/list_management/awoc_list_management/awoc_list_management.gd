@tool
class_name AWOCListManagement
extends AWOCListManagementBase

var awoc_manager_library: AWOCLibraryManager


func populate_control() -> void:
	populate_control_with_type(AWOCResourceType.Type.AWOC, AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.AWOC_ROW_PATH))


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		set_resource_modified(result)


func _ready() -> void:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	awoc_manager_library = awoc_manager.awoc_resource_manager
	if awoc_manager_library == null:
		set_error("Failed to load AWOC manager library")
		return
	populate_control()
	super._ready()
