@tool
class_name AWOCManagerResourceController extends AWOCResourceControllerBase

var awoc_manager_resource: AWOCManager
var awoc_manager_path: String = "res://addons/awoc/start_here/awoc_manager.res"

func get_awoc_controller(awoc_name: String) -> AWOCResourceController:
	var awoc = load_resource(awoc_name, awoc_manager_resource.awoc_uid_dictionary[awoc_name])
	return AWOCResourceController.new(awoc, awoc_manager_resource.awoc_uid_dictionary[awoc_name])

func save_awoc_manager():
	ResourceSaver.save(awoc_manager_resource, awoc_manager_path)
	scan()
	awoc_manager_resource.emit_changed()

func add_new_awoc(awoc_name: String, path: String):
	var new_awoc_resource: AWOC = AWOC.new()
	new_awoc_resource.awoc_name = awoc_name
	create_disk_resource(new_awoc_resource, awoc_name, path, awoc_manager_resource.awoc_uid_dictionary)
	save_awoc_manager()
	
func remove_awoc(awoc_name: String):
	var awoc: AWOC = load(ResourceUID.get_id_path(awoc_manager_resource.awoc_uid_dictionary[awoc_name]))
	if awoc.skeleton_uid != 0:
		remove_resource_from_disk(awoc.skeleton_uid)
	for mesh in awoc.mesh_uids_dictionary:
		remove_resource_from_disk(awoc.mesh_uids_dictionary[mesh])
	remove_disk_resource(awoc_name, awoc_manager_resource.awoc_uid_dictionary[awoc_name], awoc_manager_resource.awoc_uid_dictionary)
	save_awoc_manager()
	
func rename_awoc(old_name: String, new_name: String):
	var awoc_controller: AWOCResourceController = get_awoc_controller(old_name)
	awoc_controller.awoc_resource.awoc_name = new_name
	awoc_controller.save_awoc()
	rename_disk_resource(old_name, new_name, awoc_manager_resource.awoc_uid_dictionary[old_name], awoc_manager_resource.awoc_uid_dictionary)
	save_awoc_manager()
	
func get_dictionary() -> Dictionary:
	return awoc_manager_resource.awoc_uid_dictionary

func load_awoc_manager():
	if FileAccess.file_exists(awoc_manager_path):
		awoc_manager_resource = load(awoc_manager_path)
	else:
		awoc_manager_resource = AWOCManager.new()
		create_resource_on_disk(awoc_manager_resource, "awoc_manager", awoc_manager_path.get_base_dir())
	
func _init():
	load_awoc_manager()
