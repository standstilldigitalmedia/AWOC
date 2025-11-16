@tool
extends Node

signal awoc_loaded
signal awoc_closed
signal awoc_data_changed 

var current_awoc: AWOCResource = null


func set_current_awoc(awoc: AWOCResource):
	current_awoc = awoc
	awoc_loaded.emit()
	
	
func load_awoc(path: String):
	current_awoc = load(path)
	if current_awoc:
		awoc_loaded.emit()


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
		emit_signal("awoc_data_changed")
