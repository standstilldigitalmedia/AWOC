@tool
class_name AWOCMeshTab
extends AWOCTabBase

func set_manage_button_state() -> void:
	if AWOCManager.has_resources(AWOCResourceType.Type.Mesh):
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
