@tool
class_name AWOCGlobalManager
extends Node

var awoc_resource_manager: AWOCLibraryManager


func has_awocs() -> bool:
	return awoc_resource_manager.has_resources()
	
	
func create_awoc(resource_name: String, additional_data: Dictionary) -> void:
	var path = additional_data.get("path", "")
	var new_awoc_error: AWOCResourceErrorMessage = awoc_resource_manager.add_new_awoc(resource_name, path)
	if !new_awoc_error.is_successful():
		SignalBus.resource_created.emit(AWOCResourceType.Type.AWOC, resource_name, new_awoc_error)
		return
	var awoc_state = _get_awoc_state()
	if !awoc_state:
		SignalBus.resource_created.emit(AWOCResourceType.Type.AWOC, resource_name, AWOCResourceErrorMessage.new(null, "AWOC State could not be found"))
		return
	SignalBus.resource_created.emit(AWOCResourceType.Type.AWOC, resource_name, new_awoc_error)
	
	
func rename_awoc(old_name: String, new_name: String) -> void:
	var res_renamed: String = awoc_resource_manager.rename_awoc(old_name,new_name)
	var success: bool = false
	if res_renamed.is_empty():
		success = true
	SignalBus.resource_renamed.emit(AWOCResourceType.Type.AWOC, old_name, new_name, success, res_renamed)
	
	
func delete_awoc(resource_name: String) -> void:
	var res_deleted: String = awoc_resource_manager.delete_awoc(resource_name)
	var success: bool = false
	if res_deleted.is_empty():
		success = true
	SignalBus.resource_deleted.emit(AWOCResourceType.Type.AWOC, resource_name, success, res_deleted)


func _get_signal_bus() -> Node:
	return get_node_or_null("/root/SignalBus")
	
	
func _get_awoc_state() -> Node:
	return get_node_or_null("/root/AWOCState")
	
	
func _on_create_resource(resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary) -> void:
	if resource_name.is_empty():
		push_error("Must provide a resource name for resource creation")
		return
	match resource_type:
		AWOCResourceType.Type.AWOC:
			create_awoc(resource_name, additional_data)


func _on_rename_resource(resource_type: AWOCResourceType.Type, old_name: String, new_name: String) -> void:
	match resource_type:
		AWOCResourceType.Type.AWOC:
			rename_awoc(old_name, new_name)
			
			
func _on_delete_resource(resource_type: AWOCResourceType.Type, resource_name: String) -> void:
	match resource_type:
		AWOCResourceType.Type.AWOC:
			delete_awoc(resource_name)


func _ready() -> void:
	awoc_resource_manager = AWOCLibraryManager.new()
	awoc_resource_manager = awoc_resource_manager.load_welcome_resource_manager()
	var bus = _get_signal_bus()
	if bus:
		bus.create_new_resource_requested.connect(_on_create_resource)
		bus.delete_resource_requested.connect(_on_delete_resource)
		bus.rename_resource_requested.connect(_on_rename_resource)


func _exit_tree() -> void:
	var bus = _get_signal_bus()
	if bus:
		if bus.create_new_resource_requested.is_connected(_on_create_resource):
			bus.create_new_resource_requested.disconnect(_on_create_resource)
		if bus.delete_resource_requested.is_connected(_on_delete_resource):
			bus.delete_resource_requested.disconnect(_on_delete_resource)
		if bus.rename_resource_requested.is_connected(_on_rename_resource):
			bus.rename_resource_requested.disconnect(_on_rename_resource)
