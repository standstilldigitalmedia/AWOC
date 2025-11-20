@tool
class_name AWOCWelcomeTab
extends AWOCTabBase


func set_manage_button_state() -> void:
	if AWOCManager.has_awocs():
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
