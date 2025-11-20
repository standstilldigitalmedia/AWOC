@tool
class_name AWOCEditorDictionaryResourceManager
extends Resource

var parent_resource: Resource
var parent_uid: int
var parent_resource_dictionary: Dictionary


func init_resource_manager(p_resource: Resource, p_uid: int, r_dictionary: Dictionary) -> void:
	parent_resource = p_resource
	parent_uid = p_uid
	parent_resource_dictionary = r_dictionary


func validate_new_res(res_name: String) -> String:
	if !AWOCValidator.is_valid_name(res_name):
		return "The name " + res_name + " is not valid"
	if parent_resource_dictionary.has(res_name):
		return "An Resource named " + res_name + " already exists."
	return ""


func validate_delete_res(res_name: String) -> String:
	if !AWOCValidator.is_valid_name(res_name):
		return "The name " + res_name + " is not valid"
	if !parent_resource_dictionary.has(res_name):
		return "Resource " + res_name + " does not exist."
	return ""


func validate_rename_res(old_name: String, new_name: String) -> String:
	if !AWOCValidator.is_valid_name(old_name):
		return "The name " + old_name + " is not valid"
	if !AWOCValidator.is_valid_name(new_name):
		return "The name " + new_name + " is not valid"
	if old_name == new_name:
		return "New name is the same as the old name"
	if !parent_resource_dictionary.has(old_name):
		return "Resource " + old_name + " does not exist in res dictionary."
	for name in parent_resource_dictionary:
		if name == new_name:
			return "A resource named " + new_name + " already exists."
	return ""


func add_disk_resource_to_dictionary(res_name: String, uid: int) -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	resource_reference.set_uid(uid)
	parent_resource_dictionary[res_name] = resource_reference
	return ""
	


func add_resource_to_dictionary(res_name: String, res: Resource) -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary[res_name] = res
	return ""
	


func delete_resource_from_dictionary(res_name: String) -> String:
	var res_validated: String = validate_delete_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary.erase(res_name)
	return ""
	


func rename_resource_in_dictionary(old_name: String, new_name: String) -> String:
	var res_validated: String = validate_rename_res(old_name, new_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary[new_name] = parent_resource_dictionary[old_name]
	parent_resource_dictionary.erase(old_name)
	return ""
	


func has_resources() -> bool:
	return parent_resource_dictionary.size() > 0
	
	
func get_sorted_name_array() -> Array[String]:
	var return_array: Array[String] = []
	for name in parent_resource_dictionary:
		return_array.append(name)
	return_array.sort()
	return return_array


func save_parent_resource() -> String:
	var resource_saved:= ResourceSaver.save(parent_resource, ResourceUID.get_id_path(parent_uid))
	if resource_saved != OK:
		return error_string(resource_saved)
	AWOCEditorGlobal.request_scan.call_deferred()
	return ""
