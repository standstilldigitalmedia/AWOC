@tool
class_name AWOCMeshListManagement
extends AWOCListManagementBase


func populate_control() -> void:
	clear_children()
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !global_manager:
		return
	var name_array = global_manager.get_sorted_name_array(AWOCResourceType.Type.MESH)
	for awoc_name in name_array:
		var row_manager_scene: PackedScene = load(AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.MESH_ROW_PATH))
		var row_manager = row_manager_scene.instantiate()
		row_manager.set_control(awoc_name, AWOCResourceType.Type.MESH)

		if row_manager is AWOCMeshRowManagement:
			row_manager.visibility_toggled.connect(_on_mesh_visibility_toggled)

		content_container.add_child(row_manager)


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.MESH:
		set_resource_modified(result)


func _on_mesh_visibility_toggled(_toggled_on: bool) -> void:
	var any_visible: bool = false

	for child in content_container.get_children():
		if child is AWOCMeshRowManagement and child.eye_button and child.eye_button.button_pressed:
			any_visible = true
			break

	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.preview_content_changed.emit(any_visible)
