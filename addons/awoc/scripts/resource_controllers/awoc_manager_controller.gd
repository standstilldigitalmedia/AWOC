@tool
class_name AWOCManagerController extends AWOCDiskResourceController

func save_awoc_to_path():
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
	ResourceSaver.save(awoc_resource, path)
	awoc_resource.uid = ResourceLoader.get_resource_uid(path)
	ResourceSaver.save(awoc_resource, path)
	
func create_resource():
	save_resource_to_path()
	
func create_awoc_resource():
	save_awoc_to_path()
	dictionary[resource.name] = awoc_resource.uid

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
	save_resource()
	scan()
	
func rename_resource(new_name: String):
	if awoc_resource.name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !dictionary.has(resource.name):
		push_error("Resource " + awoc_resource.name + " does not exist in res dictionary.")
		return
	for name in dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	var old_name: String = awoc_resource.name
	awoc_resource.name = new_name
	dictionary[new_name] = dictionary[old_name]
	dictionary.erase(old_name)
	var old_path: String = ResourceUID.get_id_path(awoc_resource.uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(awoc_resource.uid, new_path)
	save_awoc()
	save_resource()
	scan()

func _init(awoc_manager: AWOCManager):
	resource = awoc_manager
	dictionary = awoc_manager.awoc_uid_dictionary
