@tool
class_name AWOCRowManager
extends AWOCBaseManagementRow


func _on_edit_button_pressed() -> void:
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if awoc_state:
		awoc_state.load_awoc(previous_name)
