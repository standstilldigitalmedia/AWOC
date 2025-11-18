@tool
class_name AWOCGlobalState
extends Node

signal awoc_loaded
signal awoc_closed
signal awoc_data_changed 

var current_awoc: AWOCResource = null


func has_current_awoc() -> bool:
	return current_awoc != null


func set_current_awoc(awoc: AWOCResource):
	current_awoc = awoc
	awoc_loaded.emit()
	
	
func load_awoc(path: String) -> bool:
	if !FileAccess.file_exists(path):
		push_error("AWOC file not found: " + path)
		return false
	
	var loaded_awoc = load(path)
	if !loaded_awoc or !loaded_awoc is AWOCResource:
		push_error("Failed to load AWOC or invalid resource type: " + path)
		return false
	current_awoc = loaded_awoc
	awoc_loaded.emit()
	return true


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
