@tool
class_name AWOCSlotController extends AWOCResourceControllerBase

var hide_slot_array: Array
var dictionary: Dictionary

func add_hide_slot(hide_slot_name: String):
	hide_slot_array.append(hide_slot_name)
	save_awoc()
	scan()
	
func rename_hide_slot(old_name: String, new_name: String):
	for slot in dictionary:
		for a in dictionary[slot].size():
			if old_name == dictionary[slot][a]:
				dictionary[slot][a] = new_name
				break
				
func delete_slot_from_all_hide_slot_arrays(slot_name: String):
	for slot in dictionary:
		for a in dictionary[slot].size():
			if slot_name == dictionary[slot][a]:
				dictionary[slot].remove_at(a)
				break
	save_awoc()
	scan()
	
func delete_hide_slot(hide_slot_name: String):
	for a in dictionary[resource_name].size():
		if hide_slot_name == dictionary[resource_name][a]:
			dictionary[resource_name].remove_at(a)
			break
	save_awoc()
	scan()

func create_resource():
	dictionary[resource_name] = hide_slot_array
	save_awoc()
	scan()
	
func save_resource():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_resource.uid))

"""func load_resource(load_uid: int) -> AWOCResourceBase:
	path = ResourceUID.get_id_path(load_uid)
	if !FileAccess.file_exists(path):
		push_error("AWOC Resource no longer existis on disk")
		return null
	return load(path)"""
	
func delete_resource():
	if !dictionary.has(resource_name):
		push_error("Resource " + resource_name + " does not exist.")
		return
	dictionary.erase(resource_name)
	delete_slot_from_all_hide_slot_arrays(resource_name)
	save_awoc()
	scan()
	
func rename_resource(new_name: String):
	if resource_name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !dictionary.has(resource_name):
		push_error("Resource " + resource_name + " does not exist in res dictionary.")
		return
	for name in dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	var old_name: String = resource_name
	rename_hide_slot(old_name, new_name)
	resource_name = new_name
	dictionary[new_name] = dictionary[old_name]
	dictionary.erase(old_name)
	save_awoc()
	scan()

func _init(slot_name: String, awoc: AWOC):
	awoc_resource = awoc
	resource_name = slot_name
	dictionary = awoc.slots_dictionary
	if dictionary.has(slot_name):
		hide_slot_array = dictionary[slot_name]
	else:
		hide_slot_array = Array()	
