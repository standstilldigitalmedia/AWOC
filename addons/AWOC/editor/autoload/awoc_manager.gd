@tool
class_name AWOCGlobalManager
extends Node

var awoc_resource_manager: AWOCLibraryManager
var slot_resource_manager: AWOCEditorSlotManager
var mesh_resource_manager: AWOCEditorMeshManager
"""var color_resource_manager: AWOCColorLibraryManager
var material_resource_manager: AWOCMaterialLibraryManager
var overlay_resource_manager: AWOCOverlayLibraryManager
var recipe_resource_manager: AWOCRecipeLibraryManager"""


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


func _get_manager_for_type(resource_type: AWOCResourceType.Type):
	match resource_type:
		AWOCResourceType.Type.AWOC:
			return awoc_resource_manager
		AWOCResourceType.Type.Slot:
			return slot_resource_manager
		AWOCResourceType.Type.Mesh:
			return mesh_resource_manager
		_:
			return null
	"""AWOCResourceType.Type.AWOCColor:
		return color_resource_manager
	AWOCResourceType.Type.Material:
		return material_resource_manager
	AWOCResourceType.Type.Overlay:
		return overlay_resource_manager
	AWOCResourceType.Type.Recipe:
		return recipe_resource_manager"""


func _on_create_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return
	var result: String = manager.create_resource(resource_name, additional_data)
	SignalBus.resource_modified.emit(resource_type, result)


func _on_rename_resource_requested(resource_type: AWOCResourceType.Type, old_name: String, new_name: String) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var result: String = manager.rename_resource(old_name, new_name)
	SignalBus.resource_modified.emit(resource_type, result)


func _on_delete_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var result: String = manager.delete_resource(resource_name)
	SignalBus.resource_modified.emit(resource_type, result)
	
	
func _on_awoc_loaded(awoc_name: String) -> void:
	var current_awoc: AWOCResource = AWOCState.current_awoc
	var awoc_uid = awoc_resource_manager.get_awoc_uid(awoc_name)
	slot_resource_manager.init_resource_manager(current_awoc, awoc_uid, current_awoc.slot_dictionary)
	mesh_resource_manager.init_resource_manager(current_awoc, awoc_uid, current_awoc.mesh_dictionary)


func _ready() -> void:
	awoc_resource_manager = AWOCLibraryManager.new()
	awoc_resource_manager = awoc_resource_manager.load_welcome_resource_manager()
	slot_resource_manager = AWOCEditorSlotManager.new()
	mesh_resource_manager = AWOCEditorMeshManager.new()
	var bus = get_node_or_null("/root/SignalBus")
	if bus:
		bus.create_new_resource_requested.connect(_on_create_resource_requested)
		bus.delete_resource_requested.connect(_on_delete_resource_requested)
		bus.rename_resource_requested.connect(_on_rename_resource_requested)
	var state = get_node_or_null("/root/AWOCState")
	if state:
		state.awoc_loaded.connect(_on_awoc_loaded)
