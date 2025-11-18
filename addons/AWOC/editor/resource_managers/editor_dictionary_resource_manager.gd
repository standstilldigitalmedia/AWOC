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
	

func validate_new_res(res_name: String) -> bool:
	if !AWOCValidator.is_valid_name(res_name):
		push_error("The name " + res_name + " is not valid")
		return false
	if parent_resource_dictionary.has(res_name):
		push_error("An Resource named " + res_name + " already exists.")
		return false
	return true
	
	
func validate_delete_res(res_name: String) -> bool:
	if !AWOCValidator.is_valid_name(res_name):
		push_error("The name " + res_name + " is not valid")
		return false
	if !parent_resource_dictionary.has(res_name):
		push_error("Resource " + res_name + " does not exist.")
		return false
	return true
	

func validate_rename_res(old_name: String, new_name: String) -> bool:
	if !AWOCValidator.is_valid_name(old_name):
		push_error("The name " + old_name + " is not valid")
		return false
	if !AWOCValidator.is_valid_name(new_name):
		push_error("The name " + new_name + " is not valid")
		return false
	if old_name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !parent_resource_dictionary.has(old_name):
		push_error("Resource " + old_name + " does not exist in res dictionary.")
		return false
	for name in parent_resource_dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	return true
	

func add_disk_resource_to_dictionary(res_name: String, uid: int) -> bool:
	if validate_new_res(res_name):
		var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		resource_reference.set_uid(uid)
		parent_resource_dictionary[res_name] = resource_reference
		return true
	return false
		
				
func add_resource_to_dictionary(res_name: String, res: Resource) -> bool:
	if validate_new_res(res_name):
		parent_resource_dictionary[res_name] = res
		return true
	return false
	
	
func delete_resource_from_dictionary(res_name: String) -> bool:
	if validate_delete_res(res_name):
		parent_resource_dictionary.erase(res_name)
		return true
	return false
	
	
func rename_resource_in_dictionary(old_name: String, new_name: String) -> bool:
	if validate_rename_res(old_name, new_name):
		parent_resource_dictionary[new_name] = parent_resource_dictionary[old_name]
		parent_resource_dictionary.erase(old_name)
		return true
	return false
	

func has_resources() -> bool:
	return parent_resource_dictionary.size() > 0


func get_sorted_name_array() -> Array[String]:
	var return_array: Array[String] = []
	for name in parent_resource_dictionary:
		return_array.append(name)
	return_array.sort()
	return return_array
	
	
func save_parent_resource() -> void:
	ResourceSaver.save(parent_resource, ResourceUID.get_id_path(parent_uid))
	AWOCEditorGlobal.scan.call_deferred()
