@tool
class_name AWOCResourceControllerBase extends Node

var resource_name: String
var awoc_resource: AWOC

func save_awoc():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_resource.uid))

func create_resource():
	pass
	
func delete_resource():
	pass
	
func rename_resource(new_name: String):
	pass
	
func save_resource():
	pass

func scan():
	if AWOCPlugin.SCAN_ON_RELOAD:
		EditorInterface.get_resource_filesystem().scan()
