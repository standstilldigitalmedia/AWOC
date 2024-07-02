@tool
class_name AWOCNewAWOCControl extends AWOCNewResourceControlBase

var name_line_edit: LineEdit
var path_line_edit: LineEdit
var browse_path_button: Button
var browse_path_dialog: FileDialog
var create_resource_button: Button

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
	
func on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func on_path_line_edit_text_changed(new_text: String):
	validate_inputs()

func on_browse_button_pressed():
	browse_path_dialog.visible = true
	
func on_browse_path_dialog_dir_selected(dir: String):
	path_line_edit.text = dir
	validate_inputs()
	
func on_create_resource_button_pressed():
	if validate_inputs():
		var new_awoc = AWOC.new()
		new_awoc.name = name_line_edit.text
		var new_awoc_resource_controller: AWOCDiskResourceController = AWOCDiskResourceController.new(new_awoc,resource_controller.resource_controller,resource_controller.dictionary)
		new_awoc_resource_controller.create_resource(path_line_edit.text + "/" + name_line_edit.text + ".res")
		resource_created.emit()
		
func create_controls():
	main_panel_container = PanelContainer.new()
	main_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	name_line_edit = create_line_edit("AWOC Name")
	path_line_edit = create_line_edit("Asset Creation Path")
	browse_path_button = create_browse_button()
	browse_path_dialog = create_path_browse_file_dialog("Asset Creation Path")
	create_resource_button = Button.new()
	create_resource_button.text = "Create AWOC"
	name_line_edit.text_changed.connect(on_name_line_edit_text_changed)
	path_line_edit.text_changed.connect(on_path_line_edit_text_changed)
	create_resource_button.disabled = true
	
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
	
func set_listeners():
	browse_path_button.pressed.connect(on_browse_button_pressed)
	browse_path_dialog.dir_selected.connect(on_browse_path_dialog_dir_selected)
	create_resource_button.pressed.connect(on_create_resource_button_pressed)
	
func _init(r_resource_controller: AWOCDiskResourceController):
	super(r_resource_controller)
	create_controls()
	parent_controls()
	set_listeners()
