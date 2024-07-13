@tool
class_name AWOCResourceController extends AWOCDiskResourceController

var awoc_manager_controller: AWOCManagerController

func create_resource():
	save_resource_to_path()
	dictionary[resource.name] = resource.uid
	
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
	awoc_manager_controller.save_resource()
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
	awoc_manager_controller.save_resource()
	scan()
	
func _init(awoc: AWOC, a_manager_controller: AWOCManagerController):
	resource = awoc
	awoc_manager_controller = a_manager_controller
	dictionary = awoc_manager_controller.dictionary
