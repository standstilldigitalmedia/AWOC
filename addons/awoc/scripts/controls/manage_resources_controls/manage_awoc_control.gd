@tool
class_name AWOCManageAWOCControl extends AWOCManageResourcesControlBase

signal awoc_edited(awoc: AWOCDiskResourceController)

var edit_button: Button

func on_edit_button_pressed():
	awoc_edited.emit(resource_controller)
	
func create_controls():
	edit_button = create_edit_button()
	super()
	
func set_listeners():
	edit_button.pressed.connect(on_edit_button_pressed)
	super()
	
func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(rename_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(edit_button)
	main_panel_container.add_child(hbox)
	main_panel_container.add_child(rename_confirmation_dialog)
	main_panel_container.add_child(delete_confirmation_dialog)
