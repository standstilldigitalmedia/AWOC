@tool
class_name AWOCResourceControllerBase
extends AWOCControllerBase

var _awoc_reference: AWOCEditorResourceReference


func _init(awoc_reference: AWOCEditorResourceReference) -> void:
	_awoc_reference = awoc_reference


func delete_res(res_name: String) -> bool:
	if super(res_name):
		scan()
		_awoc_reference.save_res()
		return true
	printerr("Deleting " + res_name + " failed.")
	return false
	
	
func rename_res(old_name: String, new_name: String,) -> bool:
	if super(old_name, new_name):
		scan()
		_awoc_reference.save_res()
		return true
	printerr("Rename was not successful")
	return false
