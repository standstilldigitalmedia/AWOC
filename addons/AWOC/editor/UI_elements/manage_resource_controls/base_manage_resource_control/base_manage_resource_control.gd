@tool
class_name AWOCBaseManageResourceControl
extends PanelContainer

@onready var name_line_edit: LineEdit = $MarginContainer/HBoxContainer/NameLineEdit
@onready var rename_button: Button = $MarginContainer/HBoxContainer/SaveButton
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
	var data := {
		"type" : resource_type,
		"old_name" : previous_name,
		"new_name" : name_line_edit.text
	}
	SignalBus.resource_renamed.emit(data)
	previous_name = name_line_edit.text


func _on_delete_confirmation_dialog_confirmed() -> void:
	var data := {
		"type" : resource_type,
		"name" : name_line_edit.text
	}
	SignalBus.delete_resource_requested.emit(data)
