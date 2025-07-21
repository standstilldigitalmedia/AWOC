@tool
class_name AWOCResourceControlBase
extends AWOCVBox

signal line_edit_text_changed(new_text: String)
signal rename(old_name: String, new_name: String)
signal delete(res_name: String)


var controls_hbox := AWOCHBox.new(5)
var name_line_edit: AWOCLineEdit
var rename_button := AWOCRenameIconButton.new()
var delete_button := AWOCDeleteIconButton.new()
var rename_confirmation_dialog := AWOCConfirmation_Dialog.new()
var delete_confirmation_dialog := AWOCConfirmation_Dialog.new()
var res_name: String


func create_controls(placeholder_text: String) -> void:
	name_line_edit = AWOCLineEdit.new(placeholder_text, res_name)
	
	
func parent_controls() -> void:
	controls_hbox.add_child(name_line_edit)
	controls_hbox.add_child(rename_button)
	controls_hbox.add_child(delete_button)
	add_child(controls_hbox)
	add_child(rename_confirmation_dialog)
	add_child(delete_confirmation_dialog)
	
	
func set_listeners() -> void:
	name_line_edit.text_changed.connect(_on_name_line_edit_text_change)
	rename_button.pressed.connect(_on_rename_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	rename_confirmation_dialog.confirmed.connect(_on_rename_confirmed)
	delete_confirmation_dialog.confirmed.connect(_on_delete_confirmed)
	
	
func _init(p_text: String, r_name: String) -> void:
	res_name = r_name
	add_theme_constant_override("separation", 0)
	create_controls(p_text)
	parent_controls()
	set_listeners()
	
	
func _on_rename_button_pressed() -> void:
	rename_confirmation_dialog.title = "Rename " + res_name + "?"
	rename_confirmation_dialog.dialog_text = "Are you sure you wish to rename " + res_name + " to " + name_line_edit.text + "? This action can not be undone."
	rename_confirmation_dialog.visible = true
	
	
func _on_delete_button_pressed() -> void:
	delete_confirmation_dialog.title = "Delete " + res_name + "?"
	delete_confirmation_dialog.dialog_text = "Are you sure you wish to delete " + res_name + "? This action can not be undone."
	delete_confirmation_dialog.visible = true
	

func _on_name_line_edit_text_change(new_text: String) -> void:
	if AWOCGlobal.is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true
	line_edit_text_changed.emit(new_text)
	
		
func _on_rename_confirmed() -> void:
	rename.emit(res_name, name_line_edit.text)
	
	
func _on_delete_confirmed() -> void:
	delete.emit(res_name)
	queue_free()
