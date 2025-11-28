@tool
class_name AWOCGlobalManager
extends Node

var awoc_resource_manager: AWOCLibraryManager
var slot_resource_manager: AWOCEditorSlotManager
var mesh_resource_manager: AWOCEditorMeshManager


func _get_manager_for_type(resource_type: AWOCResourceType.Type):
	match resource_type:
		AWOCResourceType.Type.AWOC:
			return awoc_resource_manager
		AWOCResourceType.Type.SLOT:
			return slot_resource_manager
		AWOCResourceType.Type.MESH:
			return mesh_resource_manager
		_:
			return null
			
			
func has_resources(resource_type: AWOCResourceType.Type) -> bool:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		return false
	return manager.has_resources()


func has_named_resource(resource_type: AWOCResourceType.Type, resource_name: String) -> bool:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		return false
	return manager.has_named_resource(resource_name)


func get_sorted_name_array(resource_type: AWOCResourceType.Type) -> Array[String]:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		return []
	return manager.get_sorted_name_array()


func _on_create_resource_requested(
	resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary
) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return
	var result: String = await manager.create_resource(resource_name, additional_data)
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.emit(resource_type, result)


func _on_rename_resource_requested(
	resource_type: AWOCResourceType.Type, old_name: String, new_name: String
) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var result: String = await manager.rename_resource(old_name, new_name)
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.emit(resource_type, result)


func _on_delete_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return
	var result: String = await manager.delete_resource(resource_name)
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.emit(resource_type, result)


func _on_awoc_loaded(awoc_name: String) -> void:
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		push_error("AWOCState not found when loading AWOC")
		return
	var current_awoc: AWOCResource = awoc_state.current_awoc
	if !current_awoc:
		push_error("Current AWOC is null in AWOCState")
		return
	var awoc_uid = awoc_resource_manager.get_awoc_uid(awoc_name)
	if awoc_uid <= 0:
		push_error("Invalid AWOC UID for: " + awoc_name)
		return
	if current_awoc.slot_dictionary == null:
		current_awoc.slot_dictionary = {}
	if current_awoc.mesh_dictionary == null:
		current_awoc.mesh_dictionary = {}
	slot_resource_manager.init_resource_manager(current_awoc, awoc_uid, current_awoc.slot_dictionary)
	mesh_resource_manager.init_resource_manager(current_awoc, awoc_uid, current_awoc.mesh_dictionary)
	awoc_state.awoc_resource_managers_ready.emit()


func _ready() -> void:
	awoc_resource_manager = AWOCLibraryManager.new()
	slot_resource_manager = AWOCEditorSlotManager.new()
	mesh_resource_manager = AWOCEditorMeshManager.new()
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.create_new_resource_requested.connect(_on_create_resource_requested)
		signal_bus.delete_resource_requested.connect(_on_delete_resource_requested)
		signal_bus.rename_resource_requested.connect(_on_rename_resource_requested)
	var awoc_state = AWOCEditorGlobal.get_awoc_state()
	if awoc_state:
		awoc_state.awoc_loaded.connect(_on_awoc_loaded)
	await awoc_resource_manager.init_library_manager()
