@tool
class_name AWOCColorControl extends AWOCResourceControlBase

var awoc_resource_controller: AWOCResourceController
var color_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var color_picker_button: ColorPickerButton
var rename_confimation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog

func _on_delete_confirmed():
	awoc_resource_controller.remove_color(color_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_color(color_name, name_line_edit.text)
	controls_reset.emit()
	
func _on_rename_button_pressed():
	rename_confimation_dialog.visible = true
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func _on_name_line_edit_text_changed(new_text: String):
	if is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true
		
func _on_color_picker_color_change(new_color: Color):
	awoc_resource_controller.change_color(color_name, color_picker_button.color)

func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit("Color Name", color_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	rename_confimation_dialog = create_rename_confirmation_dialog(color_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(color_name)
	color_picker_button = create_color_picker_button()
	super()
	
func parent_controls():
	var hide_slot_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(color_picker_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	add_child(hbox)
	super()

func _init(a_controller: AWOCResourceController, c_name: String, color: Color):
	awoc_resource_controller = a_controller
	color_name = c_name
	super()
	color_picker_button.color = color
