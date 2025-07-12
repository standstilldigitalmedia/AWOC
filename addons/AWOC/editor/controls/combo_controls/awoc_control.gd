@tool
class_name AWOCControl
extends HBoxContainer

signal rename(old_name: String, new_name: String)
signal delete(awoc_name: String)
signal edit(awoc_name: String)


var name_line_edit: AWOCLineEdit
var rename_button := AWOCRenameIconButton.new()
var delete_button := AWOCDeleteIconButton.new()
var edit_button := AWOCEditIconButton.new()
var rename_confirmation_dialog := AWOCConfirmation_Dialog.new()
var delete_confirmation_dialog := AWOCConfirmation_Dialog.new()
var awoc_name: String


func create_controls() -> void:
	name_line_edit = AWOCLineEdit.new("AWOC Name", awoc_name)
	rename_confirmation_dialog 
	delete_confirmation_dialog = AWOCConfirmation_Dialog.new()
	
func parent_controls() -> void:
	add_child(name_line_edit)
	add_child(rename_button)
	add_child(delete_button)
	add_child(edit_button)
	add_child(rename_confirmation_dialog)
	add_child(delete_confirmation_dialog)
	
	
func set_listeners() -> void:
	name_line_edit.text_changed.connect(_on_name_line_edit_text_change)
	rename_button.pressed.connect(_on_rename_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	edit_button.pressed.connect(_on_edit_button_pressed)
	rename_confirmation_dialog.confirmed.connect(_on_rename_confirmed)
	delete_confirmation_dialog.confirmed.connect(_on_delete_confirmed)
	
	
func _init(a_name: String) -> void:
	awoc_name = a_name
	create_controls()
	parent_controls()
	set_listeners()
	
	
func _on_rename_button_pressed() -> void:
	rename_confirmation_dialog.title = "Rename " + awoc_name + "?"
	rename_confirmation_dialog.dialog_text = "Are you sure you wish to rename " + awoc_name + " to " + name_line_edit.text + "? This action can not be undone."
	rename_confirmation_dialog.visible = true
	
	
func _on_delete_button_pressed() -> void:
	delete_confirmation_dialog.title = "Delete " + awoc_name + "?"
	delete_confirmation_dialog.dialog_text = "Are you sure you wish to delete " + awoc_name + "? This action can not be undone."
	delete_confirmation_dialog.visible = true
	
	
func _on_edit_button_pressed() -> void:
	edit.emit(awoc_name)
	

func _on_name_line_edit_text_change(new_text: String) -> void:
	pass
	
		
func _on_rename_confirmed() -> void:
	rename.emit(awoc_name, name_line_edit.text)
	
	
func _on_delete_confirmed() -> void:
	delete.emit(awoc_name)
