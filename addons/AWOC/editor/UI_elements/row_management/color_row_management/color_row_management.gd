@tool
class_name AWOCColorRowManagement
extends AWOCRowManagementBase

@export var color_picker_button: ColorPickerButton


func set_control(name: String, type: AWOCResourceType.Type, additional_data: Variant = null) -> void:
	super.set_control(name, type)
	if additional_data is Color and color_picker_button:
		color_picker_button.color = additional_data


func _on_color_picker_button_popup_closed() -> void:
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if global_manager:
		await global_manager.update_color(previous_name, color_picker_button.color)
