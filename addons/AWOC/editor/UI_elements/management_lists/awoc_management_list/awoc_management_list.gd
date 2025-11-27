@tool
class_name AWOCManagementList
extends AWOCManagementListBase

var awoc_manager_library: AWOCLibraryManager


func populate_control():
	clear_children()
	var awoc_row_manager_path: String = AWOCEditorGlobal.plugin_path.path_join(
		"editor/UI_elements/management_rows/awoc_management_row/awoc_row_manager.tscn"
	)
	var name_array = awoc_manager_library.get_sorted_name_array()
	for awoc_name in name_array:
		var row_manager_scene: PackedScene = load(awoc_row_manager_path)
		var row_manager = row_manager_scene.instantiate()
		row_manager.set_control(awoc_name, AWOCResourceType.Type.AWOC)
		content_container.add_child(row_manager)


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
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
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	awoc_manager_library = awoc_manager.awoc_resource_manager
	if awoc_manager_library == null:
		set_error("Failed to load AWOC manager library")
		return
	populate_control()
