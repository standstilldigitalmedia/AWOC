@tool
class_name AWOCDiskResourceController extends AWOCResourceControllerBase
	
func save_resource():
	ResourceSaver.save(resource, ResourceUID.get_id_path(resource.uid))
	
func save_resource_to_path(path: String):
	ResourceSaver.save(resource, path)
	resource.uid = ResourceLoader.get_resource_uid(path)
	ResourceSaver.save(resource, path)
	
func create_resource(path: String):
	var path_dir: String = path.get_base_dir()
	var file_name: String = path.get_file()
	if path_dir == null or path_dir.length() < 1:
		push_error("Invalid path for resource creation.")
		return
	if file_name == null or file_name.length() < 1:
		push_error("Invalid filename for resource creation.")
		return
	var dir = DirAccess.open(path_dir)
	if !dir:
		dir = DirAccess.open("res://")
		dir.make_dir_recursive(path_dir)
	save_resource_to_path(path)
	dictionary[resource.name] = resource.uid
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
	var file_path: String = ResourceUID.get_id_path(resource.uid)
	if FileAccess.file_exists(file_path):
		var base_dir = file_path.get_base_dir()
		var dir: DirAccess = DirAccess.open("res://")
		if AWOCPlugin.SEND_TO_RECYCLE:
			OS.move_to_trash(ProjectSettings.globalize_path(file_path))
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
		else:
			dir.remove(file_path)
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				dir.remove(base_dir)
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
	var old_path: String = ResourceUID.get_id_path(resource.uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(resource.uid, new_path)
	save_resource()
	scan()

