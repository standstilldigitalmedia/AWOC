@tool
class_name AWOCMeshListManagement
extends AWOCListManagementList


func populate_control():
	clear_children()
	var mesh_row_manager_path: String = AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.MESH_ROW_PATH)
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	var name_array = awoc_manager.mesh_resource_manager.get_sorted_name_array()
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
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if !signal_bus:
		return
	signal_bus.resource_modified.connect(_on_resource_modified)
	populate_control()
