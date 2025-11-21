@tool
class_name AWOCGlobalState
extends Node

signal awoc_loaded(awoc_name: String)
signal awoc_closed
signal awoc_data_changed 

var current_awoc: AWOCResource = null


func has_current_awoc() -> bool:
	return current_awoc != null
	
	
"""func set_current_awoc(awoc_error_message: AWOCResourceErrorMessage):
	if awoc_error_message.is_successful() and awoc_error_message.has_resource():
		current_awoc = awoc_error_message.resource
		awoc_loaded.emit()"""


func load_awoc(awoc_name: String) -> bool:
	var awoc_library_manager: AWOCLibraryManager = AWOCManager.awoc_resource_manager
	if !awoc_library_manager:
		push_error("AWOCLibrary manager not set")
		return false
	var path: String = awoc_library_manager.get_awoc_path(awoc_name)
	if !path.is_empty():
		if !FileAccess.file_exists(path):
			push_error("AWOC file not found: " + path)
			return false
		var loaded_awoc: AWOCResource = load(path) as AWOCResource
		if !loaded_awoc or !loaded_awoc is AWOCResource:
			push_error("Failed to load AWOC or invalid resource type: " + path)
			return false
		current_awoc = loaded_awoc
		var current_awoc_uid: int = awoc_library_manager.get_awoc_uid(awoc_name)
		AWOCManager.slot_resource_manager.init_resource_manager(current_awoc, current_awoc_uid, current_awoc.slot_dictionary)
		awoc_loaded.emit(awoc_name)
		return true
	return false
	
	
func close_awoc():
	current_awoc = null
	awoc_closed.emit()
#

func get_slot_names() -> Array[String]:
	if current_awoc:
		return current_awoc.get_slots() 
	return []
	
	
func create_new_slot(slot_name: String):
	if current_awoc:
		current_awoc.add_slot(slot_name)
		awoc_data_changed.emit()
