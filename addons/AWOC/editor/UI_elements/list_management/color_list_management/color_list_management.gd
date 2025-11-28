@tool
class_name AWOCColorListManagement
extends AWOCListManagementBase


func populate_control() -> void:
	populate_control_with_type(AWOCResourceType.Type.COLOR, AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.COLOR_ROW_PATH))


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.COLOR:
		set_resource_modified(result)
