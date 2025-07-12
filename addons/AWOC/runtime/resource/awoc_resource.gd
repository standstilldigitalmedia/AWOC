class_name AWOCResource
extends Resource

@export var slot_manager: AWOCSlotResourceManager
@export var mesh_manager: AWOCMeshResourceManager


func _init() -> void:
	slot_manager = AWOCSlotResourceManager.new()
	mesh_manager = AWOCMeshResourceManager.new()
