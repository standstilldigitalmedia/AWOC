@tool
class_name AWOCImageControl extends AWOCResourceControlBase

signal validate()

var image_name: String
var controls_vbox: VBoxContainer
var path_line_edit: LineEdit
var texture_rect: TextureRect
var browse_button: Button
var browse_file_dialog: FileDialog

func validate_inputs():
	if is_image_file(path_line_edit.text):
		texture_rect.texture = AWOCImageControl.load_image(path_line_edit.text)
	else:
		texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
	validate.emit()

func reset_controls():
	path_line_edit.text = ""
	texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
		
func _on_image_browse_pressed():
	browse_file_dialog.visible = true
			
func _on_image_file_selected(path: String):
	path_line_edit.text = path
	validate_inputs()
	
func _on_path_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func create_controls():
	controls_vbox = create_vbox(5)
	path_line_edit = create_path_line_edit("Image Path")
	texture_rect = create_texture_rect(100,100)
	browse_button = create_small_button()
	browse_button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Folder.svg")
	browse_button.pressed.connect(_on_image_browse_pressed)
	browse_file_dialog = create_file_dialog("Image File")
	browse_file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	browse_file_dialog.file_selected.connect(_on_image_file_selected)
	browse_file_dialog.clear_filters()
	browse_file_dialog.set_filters(PackedStringArray(["*.bmp ; Bitmap Images","*.jpg ; Joint Photographic Experts Group", "*.png ; Portable Network Graphics", "*.tga ; Truevision Graphics Adapter"]))
	
func parent_controls():
	super()
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hbox.add_child(path_line_edit)
	inner_hbox.add_child(browse_button)
	inner_hbox.add_child(browse_file_dialog)
	vbox.add_child(create_label(image_name))
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(texture_rect)
	controls_vbox.add_child(hbox)
	add_child(controls_vbox)

func _init(i_name: String):
	image_name = i_name
	super()
	reset_controls()
	
static func load_image(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print(str("Could not load image at: ",path))
		return
	return load(path)
