@tool
class_name AWOCManageSlotControl extends AWOCManageResourcesControlBase

var show_button: Button
var hide_button: Button

func on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	
func on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false

func create_controls():
	super()
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false

func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(rename_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	main_panel_container.add_child(hbox)
	main_panel_container.add_child(rename_confirmation_dialog)
	main_panel_container.add_child(delete_confirmation_dialog)
	
func set_listeners():
	super()
	show_button.pressed.connect(on_show_button_pressed)
	hide_button.pressed.connect(on_hide_button_pressed)
