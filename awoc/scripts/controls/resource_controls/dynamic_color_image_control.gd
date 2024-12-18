@tool
class_name AWOCDynamicColorImageControl extends AWOCImageControl

var color_picker_button: ColorPickerButton

func _on_color_picker_color_change(new_color: Color):
	validate_inputs()

func reset_controls():
	color_picker_button.color = Color(0,0,0,1)
	super()
	
func create_controls():
	color_picker_button = create_color_picker_button()
	super()
	
func parent_controls():
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	var inner_hobx2: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hobx2.add_child(create_label("Dynamic Color:"))
	inner_hobx2.add_child(color_picker_button)
	inner_hbox.add_child(path_line_edit)
	inner_hbox.add_child(browse_button)
	inner_hbox.add_child(browse_file_dialog)
	vbox.add_child(inner_hobx2)
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(texture_rect)
	controls_vbox.add_child(hbox)
	add_child(controls_vbox)
	
func _init(i_name: String):
	super(i_name)
