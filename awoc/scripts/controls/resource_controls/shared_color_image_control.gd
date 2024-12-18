@tool
class_name AWOCSharedColorImageControl extends AWOCImageControl

var shared_color_option_button: OptionButton
var colors_dictionary: Dictionary

func validate_inputs():
	if is_image_file(path_line_edit.text):
		texture_rect.texture = AWOCImageControl.load_image(path_line_edit.text)
	else:
		texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
	validate.emit()

func _on_shared_color_changed(index: int):
	shared_color_option_button.selected = index
	validate_inputs()

func set_shared_color_option_button():
	shared_color_option_button = OptionButton.new()
	shared_color_option_button.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	shared_color_option_button.clear()
	for color in colors_dictionary:
		shared_color_option_button.add_item(color)
	shared_color_option_button.selected = -1
	shared_color_option_button.item_selected.connect(_on_shared_color_changed)

func reset_controls():
	shared_color_option_button.selected = -1
	super()
	
func parent_controls():
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	var inner_hobx2: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hobx2.add_child(create_label("Shared Color:"))
	inner_hobx2.add_child(shared_color_option_button)
	inner_hbox.add_child(path_line_edit)
	inner_hbox.add_child(browse_button)
	inner_hbox.add_child(browse_file_dialog)
	vbox.add_child(inner_hobx2)
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(texture_rect)
	controls_vbox.add_child(hbox)
	add_child(controls_vbox)
	
func _init(i_name: String, c_dictionary: Dictionary):
	colors_dictionary = c_dictionary
	set_shared_color_option_button()
	super(i_name)
