@tool
class_name AWOCSlot extends AWOCResourceBase

@export var slot_name: String
@export var hide_slots_array: Array[String]

func add_hide_slot(slot: AWOCSlot):
	hide_slots_array.append(slot)
	emit_changed()
