@tool
class_name AWOCListManagementBase
extends VBoxContainer

@export var error_label: Label
@export var content_container: VBoxContainer


func clear_children() -> void:
	for child in content_container.get_children():
		if !child.is_queued_for_deletion():
			child.call_deferred("queue_free")
			

func populate_control() -> void:
	push_error("populate_control must be overridden in derived class")
	
			
func populate_control_with_type(resource_type: AWOCResourceType.Type, row_management_path: String) -> void:
	clear_children()
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !global_manager:
		return
	var name_array = global_manager.get_sorted_name_array(resource_type)
	for awoc_name in name_array:
		var row_manager_scene: PackedScene = load(row_management_path)
		var row_manager = row_manager_scene.instantiate()
		row_manager.set_control(awoc_name, resource_type)
		content_container.add_child(row_manager)
		
		
func set_error(error_message: String = "") -> void:
	if not error_label:
		push_error("Error label must be assigned.")
		return
	if error_message.is_empty():
		error_label.hide()
	else:
		error_label.text = error_message
		error_label.show()
		
func set_resource_modified(result: String) -> void:
	if result.is_empty():
		populate_control()
	else:
		set_error(result)
	
			
func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	push_error("_on_resource_modified must be overridden in derived class")
		
		
func _on_awoc_resource_managers_ready() -> void:
	populate_control()
		
		
func _ready() -> void:
	set_error()
	var global_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if global_state:
		global_state.awoc_resource_managers_ready.connect(_on_awoc_resource_managers_ready)
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if !signal_bus:
		return
	signal_bus.resource_modified.connect(_on_resource_modified)
