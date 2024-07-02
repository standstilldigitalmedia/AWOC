@tool
class_name AWOCResourceControllerBase extends Node

var resource: AWOCResourceBase
var resource_controller: AWOCResourceBase
var dictionary: Dictionary

func scan():
	if AWOCPlugin.SCAN_ON_RELOAD:
		EditorInterface.get_resource_filesystem().scan()
	
func save_resource_controller():
	ResourceSaver.save(resource_controller, ResourceUID.get_id_path(resource_controller.uid))
	
func _init(cr_resource: AWOCResourceBase, cr_resource_controller: AWOCResourceBase, dict: Dictionary):
	resource = cr_resource
	resource_controller = cr_resource_controller
	dictionary = dict
