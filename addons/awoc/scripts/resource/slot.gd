class_name AWOCSlot extends AWOCResourceBase

@export var hide_slot_dictionary: Dictionary

func add_hide_slot(slot: AWOCSlot):
	hide_slot_dictionary[slot.name] = slot
	emit_changed()
