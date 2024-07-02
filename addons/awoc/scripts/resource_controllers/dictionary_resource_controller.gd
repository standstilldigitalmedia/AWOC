@tool
class_name AWOCDictionaryResourceController extends AWOCResourceControllerBase
	
func create_resource():
	dictionary[resource.name] = resource
	save_resource_controller()
	scan()

"""func load_resource(load_uid: int) -> AWOCResourceBase:
	path = ResourceUID.get_id_path(load_uid)
	if !FileAccess.file_exists(path):
		push_error("AWOC Resource no longer existis on disk")
		return null
	return load(path)"""
	
func delete_resource():
	if !dictionary.has(resource.name):
		push_error("Resource " + resource.name + " does not exist.")
		return
	dictionary.erase(resource.name)
	save_resource_controller()
	scan()
	
func rename_resource(new_name: String):
	if resource.name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !dictionary.has(resource.name):
		push_error("Resource " + resource.name + " does not exist in res dictionary.")
		return
	for name in dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	var old_name: String = resource.name
	resource.name = new_name
	dictionary[new_name] = dictionary[old_name]
	dictionary.erase(old_name)
	save_resource_controller()
	scan()
