@tool
class_name AWOCEditorColorResourceManager
extends AWOCEditorDictionaryResourceManager


func create_resource(resource_name: String, additional_data: Dictionary) -> String:
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		return "GlobalState could not be found"
	if !awoc_state.current_awoc:
		return "An AWOC has not been selected"
	if awoc_state.current_awoc.has_color(resource_name):
		return "A Color named " + resource_name + " already exists"
	if !AWOCValidator.is_valid_name(resource_name):
		return "Please enter a valid slot name"
	if !additional_data.has(AWOCEditorGlobal.ADDITIONAL_DATA_COLOR):
		return "Addional data must include a color"
	var new_color: AWOCColor = AWOCColor.new()
	new_color.color = additional_data.get(AWOCEditorGlobal.ADDITIONAL_DATA_COLOR)
	return add_resource_to_dictionary(resource_name, new_color)


func rename_resource(old_name: String, new_name: String) -> String:
	return rename_resource_in_dictionary(old_name, new_name)


func delete_resource(resource_name: String) -> String:
	return delete_resource_from_dictionary(resource_name)
