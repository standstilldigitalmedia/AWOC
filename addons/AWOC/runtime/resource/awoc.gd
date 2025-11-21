@tool
class_name AWOCResource
extends Resource

@export var slot_dictionary: Dictionary[String, AWOCSlot]


func has_slot(slot_name: String) -> bool:
	return slot_dictionary.has(slot_name)
	
