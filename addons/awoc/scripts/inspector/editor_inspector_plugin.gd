class_name AWOCEditorInspectorPlugin extends EditorInspectorPlugin

func _can_handle(object):
	return true
	
func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	"""if object is AWOCManager:
		if name == "awoc_uid_dictionary":
			var awoc_manager_controller = AWOCResourceControllerBase.new(object, "", {}, AWOCManager.AWOC_MANAGER_PATH)
			add_property_editor(name, AWOCManagerEditorProperty.new(awoc_manager_controller))
		return true
	elif object is AWOC:
		if name == "slots_dictionary":
			var awoc_resource_controller: AWOCResourceControllerBase = AWOCResourceControllerBase.new(object, "", {})
			add_property_editor(name, AWOCEditorProperty.new(awoc_resource_controller))
		return true
	else:
		return false"""
	return false
