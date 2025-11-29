@tool
class_name AWOCEditorDictionaryResourceManager
extends Resource

@export var parent_resource_dictionary: Dictionary
var parent_resource: Resource
var parent_uid: int
var parent_resource_path: String
var use_uid_priority: bool = true 


func init_resource_manager(p_resource: Resource, p_uid: int, r_dictionary: Dictionary, p_path: String = "") -> void:
	parent_resource = p_resource
	parent_uid = p_uid
	parent_resource_dictionary = r_dictionary
	parent_resource_path = p_path


func save_parent_resource() -> String:
	var save_path: String = ""

	if use_uid_priority:

		if parent_uid != ResourceUID.INVALID_ID:
			var uid_path = ResourceUID.get_id_path(parent_uid)
			if !uid_path.is_empty() and FileAccess.file_exists(uid_path):
				save_path = uid_path

		if save_path.is_empty() and !parent_resource_path.is_empty():
			save_path = parent_resource_path
	else:

		if !parent_resource_path.is_empty():
			save_path = parent_resource_path

		elif parent_uid != ResourceUID.INVALID_ID:
			var uid_path = ResourceUID.get_id_path(parent_uid)
			if !uid_path.is_empty() and FileAccess.file_exists(uid_path):
				save_path = uid_path

	if save_path.is_empty():
		return "Cannot save parent resource: no valid path available"

	var resource_saved := ResourceSaver.save(parent_resource, save_path)
	if resource_saved != OK:
		return error_string(resource_saved)
	return ""


func validate_new_res(res_name: String) -> String:
	if !AWOCValidator.is_valid_name(res_name):
		return "The name " + res_name + " is not valid"
	if parent_resource_dictionary.has(res_name):
		return "An Resource named " + res_name + " already exists."
	return ""


func validate_delete_res(res_name: String) -> String:
	if !parent_resource_dictionary.has(res_name):
		return "Resource " + res_name + " does not exist."
	return ""


func validate_rename_res(old_name: String, new_name: String) -> String:
	if !parent_resource_dictionary.has(old_name):
		return "Resource " + old_name + " does not exist."
	if !AWOCValidator.is_valid_name(new_name):
		return "The name " + new_name + " is not valid"
	if old_name == new_name:
		return "New name is the same as the old name"
	if parent_resource_dictionary.has(new_name):
		return "A resource named " + new_name + " already exists."
	return ""


func add_disk_resource_to_dictionary(res_name: String, uid: int, full_path: String = "") -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated

	var ref_path: String = ""
	if !full_path.is_empty():

		if !AWOCValidator.is_valid_path_string(full_path):
			return "Invalid path provided: " + full_path
		ref_path = full_path
	else:

		ref_path = ResourceUID.get_id_path(uid)

	var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	resource_reference.set_uid(uid)
	if !ref_path.is_empty():
		resource_reference.set_ref_path(ref_path)

	parent_resource_dictionary[res_name] = resource_reference
	var save_parent: String = save_parent_resource()
	if !save_parent.is_empty():
		return save_parent
	return ""


func add_resource_to_dictionary(res_name: String, res: Variant) -> String:
	var res_validated: String = validate_new_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary[res_name] = res
	var save_parent: String = save_parent_resource()
	if !save_parent.is_empty():
		return save_parent
	return ""


func delete_resource_from_dictionary(res_name: String) -> String:
	var res_validated: String = validate_delete_res(res_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary.erase(res_name)
	var save_parent: String = save_parent_resource()
	if !save_parent.is_empty():
		return save_parent
	return ""


func rename_resource_in_dictionary(old_name: String, new_name: String) -> String:
	var res_validated: String = validate_rename_res(old_name, new_name)
	if !res_validated.is_empty():
		return res_validated
	parent_resource_dictionary[new_name] = parent_resource_dictionary[old_name]
	parent_resource_dictionary.erase(old_name)
	var save_parent: String = save_parent_resource()
	if !save_parent.is_empty():
		return save_parent
	return ""


func has_resources() -> bool:
	return parent_resource_dictionary.size() > 0


func has_named_resource(resource_name: String) -> bool:
	return parent_resource_dictionary.has(resource_name)


func get_sorted_name_array() -> Array[String]:
	var return_array: Array[String] = []
	for name in parent_resource_dictionary:
		return_array.append(name)
	return_array.sort()
	return return_array


func create_resource(_resource_name: String, _additional_data: Dictionary) -> String:
	return "create_resource must be overridden in derived class"


func rename_resource(_old_name: String, _new_name: String) -> String:
	return "rename_resource must be overridden in derived class"


func delete_resource(_resource_name: String) -> String:
	return "delete_resource must be overridden in derived class"
