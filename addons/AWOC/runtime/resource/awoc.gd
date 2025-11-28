@tool
class_name AWOCResource
extends Resource

@export var slot_dictionary: Dictionary = {}
@export var skeleton_reference: AWOCResourceReference = null
@export var mesh_dictionary: Dictionary = {}
@export var color_dictionary: Dictionary = {}


func has_slot(slot_name: String) -> bool:
	if slot_dictionary == null:
		slot_dictionary = {}
	return slot_dictionary.has(slot_name)
	
	
func has_color(color_name: String) -> bool:
	if color_dictionary == null:
		color_dictionary = {}
	return color_dictionary.has(color_name)
