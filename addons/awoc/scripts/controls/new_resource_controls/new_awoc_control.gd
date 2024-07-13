@tool
class_name AWOCNewAWOCControl extends AWOCNewResourceControlBase

var name_line_edit: LineEdit
var path_line_edit: LineEdit
var browse_path_button: Button
var browse_path_dialog: FileDialog
var create_resource_button: Button
var awoc_manager_controller: AWOCManagerController

func reset_inputs():
	name_line_edit.text = ""
	path_line_edit.text = ""
	create_resource_button.disabled = true

func validate_inputs() -> bool:
	if !is_valid_name(name_line_edit.text):
		create_resource_button.disabled = true
		return false
	if !path_line_edit.text.is_absolute_path():
		create_resource_button.disabled = true
		return false
	create_resource_button.disabled = false
	return true
	
func _on_browse_button_pressed():
	browse_path_dialog.current_dir = "res://"
	browse_path_dialog.visible = true
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_path_line_edit_text_changed(new_text: String):
	validate_inputs()

func _on_path_selected(dir: String):
	path_line_edit.text = dir
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	if validate_inputs():
		var new_awoc = AWOC.new()
		new_awoc.name = name_line_edit.text
		var awoc_controller: AWOCResourceController = AWOCResourceController.new(new_awoc, awoc_manager_controller)
		awoc_controller.path = path_line_edit.text + "/" + name_line_edit.text + ".res"
		awoc_controller.create_resource()
		awoc_controller.awoc_manager_controller.save_resource()
		awoc_controller.scan()
		resource_created.emit()
		
func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	name_line_edit = create_name_line_edit("AWOC Name")
	path_line_edit = create_path_line_edit("Asset Creation Path")
	browse_path_button = create_browse_button()
	browse_path_dialog = create_path_browse_file_dialog("Asset Creation Path")
	create_resource_button = create_add_new_resource_button("Create AWOC")
	
func parent_controls():
	var hbox: HBoxContainer = create_hbox(10)
	var vbox: VBoxContainer = create_vbox(10)
	hbox.add_child(path_line_edit)
	hbox.add_child(browse_path_button)
	vbox.add_child(name_line_edit)
	vbox.add_child(hbox)
	vbox.add_child(create_resource_button)
	vbox.add_child(browse_path_dialog)
	main_panel_container.add_child(vbox)

func _init(a_resource_controller: AWOCManagerController):
	awoc_manager_controller = a_resource_controller
	create_controls()
	parent_controls()
