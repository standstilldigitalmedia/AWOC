@tool
class_name AWOCManagementList
extends AWOCManagementListBase

var awoc_manager_library: AWOCLibraryManager


func populate_control():
	clear_children()
	var awoc_row_manager_path: String = AWOCEditorGlobal.PLUGIN_PATH.path_join("editor/UI_elements/management_rows/awoc_management_row/awoc_row_manager.tscn")
	var name_array = awoc_manager_library.get_sorted_name_array()
	for awoc_name in name_array:
		var row_manager_scene: PackedScene = load(awoc_row_manager_path)
		var row_manager = row_manager_scene.instantiate()
		row_manager.set_control(awoc_name, AWOCResourceType.Type.AWOC)
		content_container.add_child(row_manager)
		
		
func _on_awoc_created(resource_type: AWOCResourceType.Type, resource_name: String, result: AWOCResourceErrorMessage) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		if result.is_successful():
			populate_control()
		else:
			set_error(result.error_message)


func _on_awoc_deleted(resource_type: AWOCResourceType.Type, resource_name: String, success: bool, error: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		if success:
			populate_control()
		else:
			set_error(error)
			
			
func _on_awoc_renamed(resource_type: AWOCResourceType.Type, old_name: String, new_name: String, success: bool, error: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		if success:
			populate_control()
		else:
			set_error(error)


func _ready() -> void:
	set_error()
	SignalBus.resource_created.connect(_on_awoc_created)
	SignalBus.resource_deleted.connect(_on_awoc_deleted)
	SignalBus.resource_renamed.connect(_on_awoc_renamed)
	awoc_manager_library = AWOCManager.awoc_resource_manager
	if awoc_manager_library == null:
		set_error("Failed to load AWOC manager library")
		return
	populate_control()
	
