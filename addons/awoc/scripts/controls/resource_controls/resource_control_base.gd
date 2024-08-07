@tool
class_name AWOCResourceControlBase extends AWOCControlBase

signal resource_renamed()
signal resource_deleted()

var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var rename_confirmation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog

func create_controls():
	main_panel_container = create_transparent_panel_container()
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	
func parent_controls():
	pass

func _on_line_edit_text_changed(new_text: String):
	pass

func _on_rename_button_pressed():
	rename_confirmation_dialog.visible = true
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func _on_delete_confirmed():
	resource_deleted.emit()
	
func _on_rename_confirmed():
	resource_renamed.emit()
