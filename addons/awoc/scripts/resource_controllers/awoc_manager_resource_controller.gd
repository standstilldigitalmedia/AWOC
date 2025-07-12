@tool
class_name AWOCManagerResourceController extends AWOCResourceControllerBase

var awoc_manager_resource: AWOCManager
var awoc_manager_path: String = "res://addons/awoc/start_here/awoc_manager.res"

func pre_build():
	for awoc_name in awoc_manager_resource.awocs_dictionary:
		var awoc: AWOC = load_resource(awoc_name, awoc_manager_resource.awocs_dictionary[awoc_name].resource_uid)

func get_awoc_controller(awoc_name: String) -> AWOCResourceController:
	if !awoc_manager_resource.awocs_dictionary.has(awoc_name):
		printerr("AWOC " + awoc_name + " does not exist in dictionary")
		return null
	var awoc = load_resource(awoc_name, awoc_manager_resource.awocs_dictionary[awoc_name].resource_uid)
	return AWOCResourceController.new(awoc, awoc_manager_resource.awocs_dictionary[awoc_name].resource_uid)

func save_awoc_manager():
	ResourceSaver.save(awoc_manager_resource, awoc_manager_path)
	scan()
	awoc_manager_resource.emit_changed()

func add_new_awoc(awoc_name: String, path: String):
	var new_awoc_resource: AWOC = AWOC.new()
	new_awoc_resource.awoc_name = awoc_name
	create_disk_resource(new_awoc_resource, awoc_name, path, awoc_manager_resource.awocs_dictionary)
	save_awoc_manager()
	
func remove_awoc(awoc_name: String):
	var awoc: AWOC = load(ResourceUID.get_id_path(awoc_manager_resource.awocs_dictionary[awoc_name].resource_uid))
	if awoc.skeleton_resource_reference != null:
		remove_resource_from_disk(awoc.skeleton_resource_reference.resource_uid)
	for mesh in awoc.meshes_dictionary:
		remove_resource_from_disk(awoc.meshes_dictionary[mesh].resource_uid)
	remove_disk_resource(awoc_name, awoc_manager_resource.awocs_dictionary[awoc_name].resource_uid, awoc_manager_resource.awocs_dictionary)
	save_awoc_manager()
	
func rename_awoc(old_name: String, new_name: String):
	var awoc_controller: AWOCResourceController = get_awoc_controller(old_name)
	awoc_controller.awoc_resource.awoc_name = new_name
	awoc_controller.save_awoc()
	rename_disk_resource(old_name, new_name, awoc_manager_resource.awocs_dictionary[old_name].resource_uid, awoc_manager_resource.awocs_dictionary)
	save_awoc_manager()
	
func get_dictionary() -> Dictionary:
	return awoc_manager_resource.awocs_dictionary

func load_awoc_manager():
	if FileAccess.file_exists(awoc_manager_path):
		awoc_manager_resource = load(awoc_manager_path)
	else:
		awoc_manager_resource = AWOCManager.new()
		create_resource_on_disk(awoc_manager_resource, "awoc_manager", awoc_manager_path.get_base_dir())
	
func _init():
	load_awoc_manager()
