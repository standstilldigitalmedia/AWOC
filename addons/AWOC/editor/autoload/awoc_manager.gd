@tool
class_name AWOCGlobalManager
extends Node

var awoc_resource_manager: AWOCLibraryManager
var slot_resource_manager: AWOCEditorSlotManager
"""var color_resource_manager: AWOCColorLibraryManager
var material_resource_manager: AWOCMaterialLibraryManager
var overlay_resource_manager: AWOCOverlayLibraryManager
var mesh_resource_manager: AWOCMeshLibraryManager
var recipe_resource_manager: AWOCRecipeLibraryManager"""

# Generic interface methods
func create_resource(resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var result = manager.create_resource(resource_name, additional_data)
	SignalBus.resource_created.emit(resource_type, resource_name, result)


func rename_resource(resource_type: AWOCResourceType.Type, old_name: String, new_name: String) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var error = manager.rename_resource(old_name, new_name)
	var success = error.is_empty()
	SignalBus.resource_renamed.emit(resource_type, old_name, new_name, success, error)


func delete_resource(resource_type: AWOCResourceType.Type, resource_name: String) -> void:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		push_error("No manager found for resource type: " + str(resource_type))
		return

	var error = manager.delete_resource(resource_name)
	var success = error.is_empty()
	SignalBus.resource_deleted.emit(resource_type, resource_name, success, error)


func has_resources(resource_type: AWOCResourceType.Type) -> bool:
	var manager = _get_manager_for_type(resource_type)
	if !manager:
		return false
	return manager.has_resources()


func _get_manager_for_type(resource_type: AWOCResourceType.Type):
	match resource_type:
		AWOCResourceType.Type.AWOC:
			return awoc_resource_manager
		_:
			return null
		AWOCResourceType.Type.Slot:
			return slot_resource_manager
	"""AWOCResourceType.Type.AWOCColor:
		return color_resource_manager
	AWOCResourceType.Type.Material:
		return material_resource_manager
	AWOCResourceType.Type.Overlay:
		return overlay_resource_manager
	AWOCResourceType.Type.Mesh:
		return mesh_resource_manager
	AWOCResourceType.Type.Recipe:
		return recipe_resource_manager"""
		


func _on_create_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary) -> void:
	if resource_name.is_empty():
		push_error("Must provide a resource name for resource creation")
		return
	create_resource(resource_type, resource_name, additional_data)


func _on_rename_resource_requested(resource_type: AWOCResourceType.Type, old_name: String, new_name: String) -> void:
	rename_resource(resource_type, old_name, new_name)


func _on_delete_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String) -> void:
	delete_resource(resource_type, resource_name)


func _ready() -> void:
	awoc_resource_manager = AWOCLibraryManager.new()
	awoc_resource_manager = awoc_resource_manager.load_welcome_resource_manager()
	slot_resource_manager = AWOCEditorSlotManager.new()
	var bus = get_node_or_null("/root/SignalBus")
	if bus:
		bus.create_new_resource_requested.connect(_on_create_resource_requested)
		bus.delete_resource_requested.connect(_on_delete_resource_requested)
		bus.rename_resource_requested.connect(_on_rename_resource_requested)
