@tool
class_name AWOCColorListManagement
extends AWOCListManagementBase


func populate_control() -> void:
	clear_children()
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !global_manager:
		return
	var name_array = global_manager.get_sorted_name_array(AWOCResourceType.Type.COLOR)
	for color_name in name_array:
		var row_manager_scene: PackedScene = load(AWOCEditorGlobal.plugin_path.path_join(AWOCEditorGlobal.COLOR_ROW_PATH))
		var row_manager = row_manager_scene.instantiate()
		var color_value = global_manager.get_color(color_name)
		row_manager.set_control(color_name, AWOCResourceType.Type.COLOR, color_value)
		content_container.add_child(row_manager)


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.COLOR:
		set_resource_modified(result)
