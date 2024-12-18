@tool
class_name AWOCResourceControllerBase extends Node

func scan():
	if AWOCPlugin.SCAN_ON_FILE_CHANGE:
		EditorInterface.get_resource_filesystem().scan()

func add_resource_to_dictionary(res_name: String, dictionary: Dictionary, resource: Resource):
	if dictionary.has(res_name):
		push_error("A resource named " + res_name + " already exists.")
		return
	dictionary[res_name] = resource
	
func add_disk_resource_to_dictionary(res_name: String, uid: int, dictionary: Dictionary, path: String):
	if dictionary.has(res_name):
		push_error("A resource named " + res_name + " already exists.")
		return
	dictionary[res_name] = AWOCResourceReference.new()
	dictionary[res_name].resource_uid = uid
	var full_path: String = path + "/" + res_name + ".res"
	dictionary[res_name].path = full_path
	
func create_resource_on_disk(resource: Resource, res_name: String, path: String) -> int:
	if path == null or path.length() < 1:
		push_error("Invalid path for resource creation.")
		return 0
	if res_name == null or res_name.length() < 1:
		push_error("Invalid filename for resource creation.")
		return 0
	var dir = DirAccess.open(path)
	if !dir:
		dir = DirAccess.open("res://")
		dir.make_dir_recursive(path)
	var full_path: String = path + "/" + res_name + ".res"
	ResourceSaver.save(resource, full_path)
	return ResourceLoader.get_resource_uid(full_path)
	
func remove_resource_from_dictionary(dictionary: Dictionary, res_name: String):
	if !dictionary.has(res_name):
		push_error("Resource " + res_name + " does not exist.")
		return
	dictionary.erase(res_name)
	
func remove_resource_from_disk(uid: int):
	var file_path: String = ResourceUID.get_id_path(uid)
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
				
func rename_resource_in_dictionary(old_name: String, new_name: String, dictionary: Dictionary):
	if old_name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !dictionary.has(old_name):
		push_error("Resource " + old_name + " does not exist in res dictionary.")
		return
	for name in dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	dictionary[new_name] = dictionary[old_name]
	dictionary.erase(old_name)
				
func rename_resource_on_disk(old_name: String, new_name: String, uid: int):
	if old_name == new_name:
		push_error("New name is the same as the old name")
		return false
	var old_path: String = ResourceUID.get_id_path(uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(uid, new_path)
	
static func load_resource(res_name: String, uid: int) -> Resource:
	if uid != 0:
		var file_path = ResourceUID.get_id_path(uid)
		if !FileAccess.file_exists(file_path):
			push_error("Resource " + res_name + " no longer exists on disk")
			return null
		return load(file_path)
	return null
	
func create_disk_resource(resource: AWOCResourceBase, resource_name: String, path: String, dictionary: Dictionary):
	var uid: int = create_resource_on_disk(resource, resource_name, path)
	add_disk_resource_to_dictionary(resource_name, uid, dictionary, path)
	
func remove_disk_resource(resource_name: String, uid: int, dictionary: Dictionary):
	remove_resource_from_disk(uid)
	remove_resource_from_dictionary(dictionary, resource_name)
	
func rename_disk_resource(old_name: String, new_name: String, uid: int, dictionary: Dictionary):
	rename_resource_on_disk(old_name, new_name, uid)
	rename_resource_in_dictionary(old_name, new_name, dictionary)
