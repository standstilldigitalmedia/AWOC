@tool
class_name AWOCBaseManagementRow
extends PanelContainer

@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var rename_confirm: ConfirmationDialog
@export var delete_confirm: ConfirmationDialog

var previous_name: String = ""
var resource_type: AWOCResourceType.Type


func validate() -> void:
	if AWOCValidator.is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true


func set_control(name: String, type: AWOCResourceType.Type) -> void:
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
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.rename_resource_requested.emit(resource_type, previous_name, name_line_edit.text)


func _on_delete_confirmation_dialog_confirmed() -> void:
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.delete_resource_requested.emit(resource_type, previous_name)
