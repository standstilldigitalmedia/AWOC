@tool
class_name AWOCEditorSlotManager
extends AWOCEditorDictionaryResourceManager


func create_resource(resource_name: String, additional_data: Dictionary) -> String:
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		return "GlobalState could not be found"
	if !awoc_state.current_awoc:
		return "An AWOC has not been selected"
	if awoc_state.current_awoc.has_slot(resource_name):
		return "A slot named " + resource_name + " already exists"
	if !AWOCValidator.is_valid_name(resource_name):
		return "Please enter a valid slot name"
	if !additional_data.has("hide_slot_array"):
		return "New Slot must have a hide_slot_array"
	var new_slot: AWOCSlot = AWOCSlot.new()
	var new_hide_slot_array: Array[String] = additional_data.get("hide_slot_array")
	if new_hide_slot_array.size() > 0:
		new_slot.hide_slot_array = new_hide_slot_array
	return add_resource_to_dictionary(resource_name, new_slot)


func rename_resource(old_name: String, new_name: String) -> String:
	return rename_resource_in_dictionary(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return delete_resource_from_dictionary(resource_name)
