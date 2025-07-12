@tool
class_name AWOCControl extends AWOCResourceControlBase

signal awoc_edited(awoc_resource_controller: AWOCResourceController)

var awoc_manager_controller: AWOCManagerResourceController
var awoc_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var edit_button: Button
var rename_confimation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog

func _on_delete_confirmed():
	awoc_manager_controller.remove_awoc(awoc_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_manager_controller.rename_awoc(awoc_name, name_line_edit.text)
	controls_reset.emit()
	
func _on_edit_button_pressed():
	awoc_edited.emit(awoc_manager_controller.get_awoc_controller(awoc_name))
	
func _on_rename_button_pressed():
	rename_confimation_dialog.visible = true
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func _on_name_line_edit_text_changed(new_text: String):
	if is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true

func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit("AWOC Name", awoc_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	edit_button = create_edit_button()
	rename_confimation_dialog = create_rename_confirmation_dialog(awoc_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(awoc_name)
	super()
	
func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(edit_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	add_child(hbox)
	super()

func _init(am_controller: AWOCManagerResourceController, a_name: String):
	awoc_manager_controller = am_controller
	awoc_name = a_name
	super()
