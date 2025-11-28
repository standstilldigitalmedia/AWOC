@tool
class_name AWOCSlotListManagement
extends AWOCListManagementBase


func populate_control() -> void:
	populate_control_with_type(AWOCResourceType.Type.SLOT, AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.SLOT_ROW_PATH))


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.SLOT:
		set_resource_modified(result)
