@tool
class_name AWOCNewAWOCControl extends AWOCNewResourceControlBase

var awoc_manager_resource_controller: AWOCManagerResourceController
var name_line_edit: LineEdit
var path_line_edit: LineEdit
var path_browse_button: Button
var create_new_resource_button: Button
var path_browse_dialog: FileDialog

func reset_controls():
	name_line_edit.text = ""
	path_line_edit.text = ""
	path_browse_dialog.set_current_dir("res://")
	create_new_resource_button.disabled = true

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	if !is_valid_path(path_line_edit.text):
		create_new_resource_button.disabled = true
		return
	create_new_resource_button.disabled = false
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()

func _on_path_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_browse_button_pressed():
	path_browse_dialog.visible = true
	
func _on_path_selected(dir: String):
	path_line_edit.text = dir
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	awoc_manager_resource_controller.add_new_awoc(name_line_edit.text, path_line_edit.text)
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New AWOC")
	name_line_edit = create_name_line_edit("AWOC Name")
	path_line_edit = create_path_line_edit("Asset Creation Path")
	path_browse_button = create_browse_button()
	create_new_resource_button = create_add_new_resource_button("Create AWOC")
	path_browse_dialog = create_path_browse_file_dialog("Asset Creation Path")
	super()
	
func parent_controls():
	super()
	control_panel_container_vbox.add_child(name_line_edit)
	var hbox = create_hbox(10)
	hbox.add_child(path_line_edit)
	hbox.add_child(path_browse_button)
	control_panel_container_vbox.add_child(hbox)
	control_panel_container_vbox.add_child(create_new_resource_button)
	control_panel_container_vbox.add_child(path_browse_dialog)

func _init(am_resource_controller: AWOCManagerResourceController):
	awoc_manager_resource_controller = am_resource_controller
	super()
