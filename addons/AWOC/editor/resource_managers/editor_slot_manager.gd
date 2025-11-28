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
	var new_slot: AWOCSlot = AWOCSlot.new()
	return add_resource_to_dictionary(resource_name, new_slot)


func rename_resource(old_name: String, new_name: String) -> String:
	return rename_resource_in_dictionary(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return delete_resource_from_dictionary(resource_name)
