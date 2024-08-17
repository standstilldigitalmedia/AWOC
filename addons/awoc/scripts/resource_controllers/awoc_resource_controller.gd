@tool
class_name AWOCResourceController extends AWOCResourceControllerBase

var awoc_resource: AWOC
var awoc_uid: int

func save_awoc():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_uid))
	scan()
	awoc_resource.emit_changed()
	
func add_new_slot(slot_name: String, hide_slots_array: Array):
	var new_slot_resource: AWOCSlot = AWOCSlot.new()
	new_slot_resource.hide_slots_array = hide_slots_array
	add_resource_to_dictionary(slot_name, awoc_resource.slots_dictionary, new_slot_resource)
	save_awoc()
	
func remove_slot(slot_name: String):
	for slot in awoc_resource.slots_dictionary:
		var hide_slot_array: Array = awoc_resource.slots_dictionary[slot].hide_slots_array
		for a in hide_slot_array.size():
			if hide_slot_array[a] == slot_name:
				hide_slot_array.remove_at(a)
				break		
	remove_resource_from_dictionary(awoc_resource.slots_dictionary, slot_name)
	save_awoc()
	
func rename_slot(old_name: String, new_name: String):
	for slot in awoc_resource.slots_dictionary:
		var hide_slot_array: Array = awoc_resource.slots_dictionary[slot].hide_slots_array
		for a in hide_slot_array.size():
			if hide_slot_array[a] == old_name:
				hide_slot_array[a] = new_name
				break		
	rename_resource_in_dictionary(old_name, new_name, awoc_resource.slots_dictionary)
	save_awoc()
	
func add_new_hide_slot(slot_name: String, hide_slot_name: String):
	awoc_resource.slots_dictionary[slot_name].hide_slot_array.append(hide_slot_name)
	save_awoc()
	
func remove_hide_slot(slot_name: String, hide_slot_name: String):
	var hide_slot_array: Array = awoc_resource.slots_dictionary[slot_name].hide_slots_array
	for a in hide_slot_array.size():
		if hide_slot_array[a] == hide_slot_name:
			hide_slot_array.remove_at(a)
			break
	save_awoc()
	
func get_slots_dictionary() -> Dictionary:
	return awoc_resource.slots_dictionary

func _init(a_resource: AWOC, a_uid: int):
	awoc_resource = a_resource
	awoc_uid = a_uid
