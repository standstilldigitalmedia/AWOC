@tool
class_name AWOCSlotController
extends AWOCResourceControllerBase


func add_new_slot(slot_name: String) -> void:
	if res_exists(slot_name):
		printerr("A Slot named " + slot_name + " already exists.")
		return
	var reference: AWOCResourceReference = (
			AWOCResourceReference.new())
	var editor_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(reference)
	editor_reference.set_res(AWOCSlot.new())
	editor_reference.set_res_path(_awoc_reference.get_res_path().get_base_dir() + "/slots/" + slot_name + ".res")
	editor_reference.save_res()
	_awoc_reference.load_res().slot_dictionary[slot_name] = reference
	_awoc_reference.save_res()
	scan()
	
	
func _get_dictionary() -> Dictionary[String, AWOCResourceReference]:
	return _awoc_reference.load_res().slot_dictionary
