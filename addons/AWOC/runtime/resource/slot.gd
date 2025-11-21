@tool
class_name AWOCSlot
extends Resource

var hide_slot_array: Array[String]


func has_hide_slot(hide_slot_name: String) -> bool:
	return hide_slot_array.has(hide_slot_name)
