@tool
class_name AWOCNewColorControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var name_line_edit: LineEdit
var color_picker_button: ColorPickerButton
var create_new_resource_button: Button

func reset_controls():
	name_line_edit.text = ""
	create_new_resource_button.disabled = true
	color_picker_button.color = Color(0.0,0.0,0.0,1.0)

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	create_new_resource_button.disabled = false
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	awoc_resource_controller.add_new_color(name_line_edit.text, color_picker_button.color)
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Color")
	name_line_edit = create_name_line_edit("Color Name")
	create_new_resource_button = create_add_new_resource_button("Create Color")
	color_picker_button = create_color_picker_button()
	super()
	
func parent_controls():
	super()
	var hbox: HBoxContainer = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(color_picker_button)
	control_panel_container_vbox.add_child(hbox)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
