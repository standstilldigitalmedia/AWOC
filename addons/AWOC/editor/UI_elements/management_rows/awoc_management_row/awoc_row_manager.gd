@tool
class_name AWOCRowManager
extends AWOCBaseManagementRow


func _on_edit_button_pressed() -> void:
	AWOCState.load_awoc(previous_name)
