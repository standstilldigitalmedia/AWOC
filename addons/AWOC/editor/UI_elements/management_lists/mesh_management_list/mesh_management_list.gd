@tool
class_name AWOCMeshManagementList
extends AWOCManagementListBase


func populate_control():
	clear_children()
	var mesh_row_manager_path: String = AWOCEditorGlobal.plugin_path.path_join(
		"editor/UI_elements/management_rows/mesh_management_row/mesh_management_row.tscn"
	)
	var name_array = AWOCManager.mesh_resource_manager.get_sorted_name_array()
	for mesh_name in name_array:
		var row_manager_scene: PackedScene = load(mesh_row_manager_path)
		var row_manager = row_manager_scene.instantiate()
		row_manager.set_control(mesh_name, AWOCResourceType.Type.MESH)
		content_container.add_child(row_manager)


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.MESH:
		if result.is_empty():
			populate_control()
		else:
			set_error(result)


func _ready() -> void:
	set_error()
	SignalBus.resource_modified.connect(_on_resource_modified)
	populate_control()
