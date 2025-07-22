@tool
class_name AWOCEditorResourceManagerBase
extends Resource

var parent_resource: Resource
var parent_uid: int
var resource_dictionary: Dictionary


func init_resource_manager(p_resource: Resource, p_uid: int, r_dictionary: Dictionary) -> void:
	parent_resource = p_resource
	parent_uid = p_uid
	resource_dictionary = r_dictionary
	

func validate_new_res(res_name: String) -> bool:
	if !AWOCGlobal.is_valid_name(res_name):
		push_error("The name " + res_name + " is not valid")
		return false
	if resource_dictionary.has(res_name):
		push_error("An Resource named " + res_name + " already exists.")
		return false
	return true
	
	
func validate_delete_res(res_name: String) -> bool:
	if !AWOCGlobal.is_valid_name(res_name):
		push_error("The name " + res_name + " is not valid")
		return false
	if !resource_dictionary.has(res_name):
		push_error("Resource " + res_name + " does not exist.")
		return false
	return true
	

func validate_rename_res(old_name: String, new_name: String) -> bool:
	if !AWOCGlobal.is_valid_name(old_name):
		push_error("The name " + old_name + " is not valid")
		return false
	if !AWOCGlobal.is_valid_name(new_name):
		push_error("The name " + new_name + " is not valid")
		return false
	if old_name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !resource_dictionary.has(old_name):
		push_error("Resource " + old_name + " does not exist in res dictionary.")
		return false
	for name in resource_dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	return true
		
				
func add_resource(res_name: String, res: Resource, path: String = "") -> bool:
	if validate_new_res(res_name):
		resource_dictionary[res_name] = res
		save_parent_resource()
		return true
	return false
	
	
func delete_resource(res_name: String) -> bool:
	if validate_delete_res(res_name):
		resource_dictionary.erase(res_name)
		save_parent_resource()
		return true
	return false
	
	
func rename_resource(old_name: String, new_name: String) -> bool:
	if validate_rename_res(old_name, new_name):
		resource_dictionary[new_name] = resource_dictionary[old_name]
		resource_dictionary.erase(old_name)
		save_parent_resource()
		return true
	return false
	

func has_resources() -> bool:
	if get_dictionary().size() > 0:
		return true
	return false


func get_dictionary() -> Dictionary:
	return resource_dictionary
	
	
func get_sorted_name_array() -> Array[String]:
	var return_array: Array[String] = []
	for name in resource_dictionary:
		return_array.append(name)
	return_array.sort()
	return return_array
	
	
func save_parent_resource() -> void:
	ResourceSaver.save(parent_resource, ResourceUID.get_id_path(parent_uid))
	parent_resource.emit_changed()
