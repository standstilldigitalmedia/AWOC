@tool
class_name AWOCResourceControllerBase extends Node

var resource: AWOCResourceBase
var resource_name: String
var dictionary: Dictionary
var path: String = ""
var uid: int = 0
		
func save_resource():
	if path != "":
		ResourceSaver.save(resource, path)
	elif uid != 0:
		ResourceSaver.save(resource, ResourceUID.get_id_path(uid))

func create_disk_resource_in_dictionary():
	dictionary[resource_name] = uid

func create_resource_in_dictionary():
	dictionary[resource_name] = resource
	
func create_resource_on_disk():
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
	ResourceSaver.save(resource, path)
	uid = ResourceLoader.get_resource_uid(path)
	
func delete_resource_from_dictionary():
	if !dictionary.has(resource_name):
		push_error("Resource " + resource_name + " does not exist.")
		return
	dictionary.erase(resource_name)
	
func delete_resource_from_disk():
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
				
func rename_resource_in_dictionary(new_name: String):
	if resource_name == new_name:
		push_error("New name is the same as the old name")
		return false
	if !dictionary.has(resource_name):
		push_error("Resource " + resource_name + " does not exist in res dictionary.")
		return
	for name in dictionary:
		if name == new_name:
			push_error("A resource named " + new_name + " already exists.")
			return false
	var old_name: String = resource_name
	dictionary[new_name] = dictionary[old_name]
	dictionary.erase(old_name)
	
func rename_resource_on_disk(new_name: String):
	if resource_name == new_name:
		push_error("New name is the same as the old name")
		return false
	var old_path: String = ResourceUID.get_id_path(uid)
	var new_path: String = old_path.get_base_dir() + "/" + new_name + ".res"
	var dir: DirAccess = DirAccess.open("res://")
	dir.rename(old_path, new_path)
	ResourceUID.set_id(uid, new_path)

func load_resource():
	if path != "":
		if !FileAccess.file_exists(path):
			push_error("Resource " + resource_name + " no longer existis on disk")
			return
		resource = load(path)
	elif uid != 0:
		var file_path = ResourceUID.get_id_path(uid)
		if !FileAccess.file_exists(file_path):
			push_error("Resource " + resource_name + " no longer existis on disk")
			return
		resource = load(file_path)
	
"""func save_awoc_resource():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_resource.uid))
	
func load_resource(load_uid: int) -> AWOCResourceBase:
	path = ResourceUID.get_id_path(load_uid)
	if !FileAccess.file_exists(path):
		push_error("AWOC Resource no longer existis on disk")
		return null
	return load(path)

func load_resource(load_uid: int) -> AWOCResourceBase:
	path = ResourceUID.get_id_path(load_uid)
	if !FileAccess.file_exists(path):
		push_error("AWOC Resource no longer existis on disk")
		return null
	return load(path)"""
	
func _init(res_name: String, dict: Dictionary, res_uid: int, res_path: String):
	resource_name = res_name
	dictionary = dict
	uid = res_uid
	path = res_path
	load_resource()
