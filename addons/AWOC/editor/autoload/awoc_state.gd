@tool
extends Node

signal awoc_loaded
signal awoc_closed
signal awoc_data_changed 

var current_awoc: AWOCResource = null


func load_awoc(path: String):
	current_awoc = load(path)
	if current_awoc:
		emit_signal("awoc_loaded")


func close_awoc():
	current_awoc = null
	emit_signal("awoc_closed")

#
func get_slot_names() -> Array[String]:
	if current_awoc:
		return current_awoc.get_slots() 
	return []


func create_new_slot(slot_name: String):
	if current_awoc:
		current_awoc.add_slot(slot_name)
		emit_signal("awoc_data_changed")
