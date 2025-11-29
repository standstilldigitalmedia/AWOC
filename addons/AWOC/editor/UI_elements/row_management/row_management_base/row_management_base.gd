@tool
class_name AWOCRowManagementBase
extends PanelContainer

@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var content_panel: PanelContainer
@export var rename_confirm: ConfirmationDialog
@export var delete_confirm: ConfirmationDialog

var previous_name: String = ""
var resource_type: AWOCResourceType.Type


func validate() -> void:
	if AWOCValidator.is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true


func set_control(name: String, type: AWOCResourceType.Type, additional_data: Variant = null) -> void:
	previous_name = name
	resource_type = type
	name_line_edit.text = name
	validate()


func _on_name_line_edit_text_changed(_new_text: String) -> void:
	validate()


func _on_rename_button_pressed() -> void:
	rename_confirm.title = "Rename " + previous_name + "?"
	rename_confirm.dialog_text = "Are you sure you wish to rename " + previous_name + " to " + name_line_edit.text + "? This can not be undone."
	rename_confirm.show()


func _on_delete_button_pressed() -> void:
	delete_confirm.title = "Delete " + previous_name + "?"
	delete_confirm.dialog_text = "Are you sure you wish to delete " + previous_name + "? This can not be undone."
	delete_confirm.show()


func _on_rename_confirmation_dialog_confirmed() -> void:
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if global_manager:
		await global_manager.rename_resource(resource_type, previous_name, name_line_edit.text)


func _on_delete_confirmation_dialog_confirmed() -> void:
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if global_manager:
		await global_manager.delete_resource(resource_type, previous_name)
		
