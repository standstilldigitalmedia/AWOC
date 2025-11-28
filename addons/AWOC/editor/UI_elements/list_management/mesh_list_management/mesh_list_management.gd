@tool
class_name AWOCMeshListManagement
extends AWOCListManagementList


func populate_control() -> void:
	populate_control_with_type(AWOCResourceType.Type.MESH, AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.MESH_ROW_PATH))


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.MESH:
		set_resource_modified(result)
