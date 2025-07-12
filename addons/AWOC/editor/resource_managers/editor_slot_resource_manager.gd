@tool
class_name AWOCEditorSlotResourceManager
extends AWOCEditorDictionaryResourceManager


func add_slot(res_name: String) -> void:
	add_resource_to_dictionary(res_name, AWOCSlotResource.new())
	save_parent_resource()
	

func delete_slot(res_name: String) -> void:
	delete_resource_from_dictionary(res_name)
	save_parent_resource()
	
	
func rename_slot(old_name: String, new_name: String) -> void:
	rename_resource_in_dictionary(old_name, new_name)
	save_parent_resource()
	
	
func get_dictionary() -> Dictionary:
	return parent_resource.slot_manager.slot_dictionary
