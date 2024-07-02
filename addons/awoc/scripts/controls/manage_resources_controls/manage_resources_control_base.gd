@tool
class_name AWOCManageResourcesControlBase extends AWOCControlBase

signal resource_renamed()
signal resource_deleted()

var rename_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var rename_confirmation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog

func validate_new_name():
	if is_valid_name(rename_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true

func on_rename_line_edit_text_changed(new_text: String):
	validate_new_name()
	
func on_rename_button_pressed():
	rename_confirmation_dialog.visible = true
	
func on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func on_rename_confirmation_dialog_confirmed():
	resource_controller.rename_resource(rename_line_edit.text)
	resource_renamed.emit()
	
func on_delete_confirmation_dialog_confirmed():
	resource_controller.delete_resource()
	resource_deleted.emit()
	
func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	rename_line_edit = create_line_edit("")
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	rename_confirmation_dialog = create_rename_confirmation_dialog()
	delete_confirmation_dialog = create_delete_confirmation_dialog()
	rename_confirmation_dialog.visible = false
	delete_confirmation_dialog.visible = false
	
func set_listeners():
	rename_line_edit.text_changed.connect(on_rename_line_edit_text_changed)
	rename_button.pressed.connect(on_rename_button_pressed)
	delete_button.pressed.connect(on_delete_button_pressed)
	rename_confirmation_dialog.confirmed.connect(on_rename_confirmation_dialog_confirmed)
	delete_confirmation_dialog.confirmed.connect(on_delete_confirmation_dialog_confirmed)
	
func parent_controls():
	push_error("parent_controls() should not be called in AWOCManageResourcesControlBase")
	
func _init(r_resource_controller: AWOCResourceControllerBase):
	super(r_resource_controller)
	create_controls()
	set_listeners()
	parent_controls()
	rename_line_edit.text = r_resource_controller.resource.name
