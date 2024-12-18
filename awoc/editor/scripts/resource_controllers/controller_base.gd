@tool
class_name AWOCControllerBase
extends Resource


func _get_dictionary() -> Dictionary:
	printerr("_get_dictionary should not be called from AWOCControllerBase. This function has to be overriden.")
	return {}
	
	
func scan() -> void:
	if !Engine.is_editor_hint():
		return
	if AWOCGlobal.SCAN_ON_FILE_CHANGE:
		EditorInterface.get_resource_filesystem().scan()

		
func get_reference(res_name: String) -> AWOCEditorResourceReference:
	if !_get_dictionary().has(res_name):
		printerr("A resource named " + res_name + " does not exist.")
		return null
	return AWOCEditorResourceReference.new(_get_dictionary()[res_name])
	
	
func res_exists(res_name: String) -> bool:
	if !_get_dictionary().has(res_name):
		return false
	if get_reference(res_name).load_res() == null:
		_get_dictionary().erase(res_name)
		return false
	return true
	
	
func delete_res(res_name: String) -> bool:
	if !res_exists(res_name):
		printerr("An Resource named " + res_name + " can not be deleted because it does not exist.")
		return false
	if get_reference(res_name).delete_res():
		_get_dictionary().erase(res_name)
		return true
	return false
	
	
func rename_res(old_name: String, new_name: String,) -> bool:
	if !res_exists(old_name):
		printerr("A resource named " + old_name + " can not be renamed because it does not exist.")
		return false
	if res_exists(new_name):
		printerr("A resource named " + old_name + " can not be renamed because a resource named " + new_name + " already exists.")
		return false
	if get_reference(old_name).rename_res(new_name):
		_get_dictionary()[new_name] =  _get_dictionary()[old_name]
		_get_dictionary().erase(old_name)
		return true
	printerr("Rename was not successful")
	return false
