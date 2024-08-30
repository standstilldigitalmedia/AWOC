@tool
class_name AWOCImageControl extends AWOCResourceControlBase

signal validate()

var image_name: String
var label: Label
var texture_rect: TextureRect
var path_line_edit: LineEdit
var browse_button: Button
var file_dialog: FileDialog

func reset_controls():
	texture_rect.set_texture(load_image("res://addons/awoc/images/no_image.png"))
	path_line_edit.text = ""

func _on_file_selected(path: String):
	path_line_edit.text = path
	texture_rect.set_texture(load_image(path))
	validate.emit()

func _on_browse_button_pressed():
	file_dialog.visible = true
	
func _on_path_line_edit_text_changed(new_text: String):
	if is_image_file(path_line_edit.text):
		texture_rect.set_texture(load_image(path_line_edit.text))
	else:
		texture_rect.set_texture(load_image("res://addons/awoc/images/no_image.png"))
	validate.emit()

func create_controls():
	label = create_label(image_name)
	texture_rect = create_texture_rect(100,100)
	texture_rect.set_texture(load_image("res://addons/awoc/images/no_image.png"))
	path_line_edit = create_path_line_edit("Image path")
	browse_button = create_browse_button()
	file_dialog = create_file_open_dialog("Open Image File")
	file_dialog.clear_filters()
	file_dialog.set_filters(PackedStringArray(["*.bmp ; Bitmap Images","*.jpg ; Joint Photographic Experts Group", "*.png ; Portable Network Graphics", "*.tga ; Truevision Graphics Adapter"]))
	file_dialog.visible = false
	
func parent_controls():
	var outer_hbox: HBoxContainer = create_hbox(10)
	var left_vbox: VBoxContainer = create_vbox(10)
	var hbox: HBoxContainer = create_hbox(10)
	left_vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	hbox.add_child(path_line_edit)
	hbox.add_child(browse_button)
	left_vbox.add_child(label)
	left_vbox.add_child(hbox)
	left_vbox.add_child(file_dialog)
	outer_hbox.add_child(left_vbox)
	outer_hbox.add_child(texture_rect)
	add_child(outer_hbox)

func _init(i_name: String):
	image_name = i_name
	super()

func load_image(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print(str("Could not load image at: ",path))
		return
	return load(path)
