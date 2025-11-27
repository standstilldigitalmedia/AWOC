@tool
class_name AWOCWelcomeTab
extends AWOCTabBase


func set_manage_button_state() -> void:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	if awoc_manager.has_resources(AWOCResourceType.Type.AWOC):
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
