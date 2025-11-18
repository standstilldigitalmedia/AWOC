@tool
class_name AWOCBaseManageResourceControl
extends PanelContainer

@onready var name_line_edit: LineEdit = $MarginContainer/HBoxContainer/NameLineEdit
@onready var rename_button: Button = $MarginContainer/HBoxContainer/RenameButton
@onready var rename_confirm: ConfirmationDialog = $RenameConfirmationDialog
@onready var delete_confirm: ConfirmationDialog = $DeleteConfirmationDialog
var previous_name: String = ""
var resource_type: String = ""
	
	
func validate() -> void:
	if AWOCValidator.is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true
		
		
func set_control(name: String, type: String) -> void:
	previous_name = name
	resource_type = type
	name_line_edit.text = name
	validate()
	

func _on_name_line_edit_text_changed(new_text: String) -> void:
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
	SignalBus.resource_renamed.emit(resource_type, previous_name, name_line_edit.text)
	previous_name = name_line_edit.text


func _on_delete_confirmation_dialog_confirmed() -> void:
	SignalBus.delete_resource_requested.emit(resource_type, name_line_edit.text)
