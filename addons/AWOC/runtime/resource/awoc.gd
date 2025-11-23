@tool
class_name AWOCResource
extends Resource

@export var slot_dictionary: Dictionary[String, AWOCSlot]
@export var skeleton_reference: AWOCResourceReference
@export var mesh_dictionary: Dictionary[String, AWOCResourceReference]


func has_slot(slot_name: String) -> bool:
	return slot_dictionary.has(slot_name)
	
