@tool
class_name AWOOverlayImageControl extends AWOCResourceControlBase
signal validate()

var image_name: String
var colors_dictionary: Dictionary
var image_controls_vbox: VBoxContainer
var shared_color_controls_vbox: VBoxContainer
var dynamic_controls_vbox: VBoxContainer
var shared_color_option_button: OptionButton
var dynamic_color_picker_button: ColorPickerButton
var image_path_line_edit: LineEdit
var dynamic_path_line_edit: LineEdit
var shared_color_path_line_edit: LineEdit
var image_texture_rect: TextureRect
var dynamic_texture_rect: TextureRect
var shared_color_texture_rect: TextureRect
var image_browse_button: Button
var dynamic_browse_button: Button
var shared_color_browse_button: Button
var image_browse_file_dialog: FileDialog
var dynamic_browse_file_dialog: FileDialog
var shared_color_browse_file_dialog: FileDialog

func create_image_controls():
	image_controls_vbox = create_vbox(5)
	image_path_line_edit = create_path_line_edit("Image Path")
	image_texture_rect = create_texture_rect(100,100)
	image_browse_button = create_small_button()
	image_browse_button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Folder.svg")
	image_browse_button.pressed.connect(_on_image_browse_pressed)
	image_browse_file_dialog = create_file_dialog("Image File")
	image_browse_file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	image_browse_file_dialog.file_selected.connect(_on_image_file_selected)
	image_browse_file_dialog.clear_filters()
	image_browse_file_dialog.set_filters(PackedStringArray(["*.bmp ; Bitmap Images","*.jpg ; Joint Photographic Experts Group", "*.png ; Portable Network Graphics", "*.tga ; Truevision Graphics Adapter"]))
	
func create_dynamic_controls():
	dynamic_controls_vbox = create_vbox(5)
	dynamic_path_line_edit = create_path_line_edit("Image Path")
	dynamic_color_picker_button = create_color_picker_button()
	dynamic_texture_rect = create_texture_rect(100,100)
	dynamic_browse_button = create_small_button()
	dynamic_browse_button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Folder.svg")
	dynamic_browse_button.pressed.connect(_on_dynamic_browse_pressed)
	dynamic_browse_file_dialog = create_file_dialog("Image File")
	dynamic_browse_file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	dynamic_browse_file_dialog.file_selected.connect(_on_dynamic_file_selected)
	dynamic_browse_file_dialog.clear_filters()
	dynamic_browse_file_dialog.set_filters(PackedStringArray(["*.bmp ; Bitmap Images","*.jpg ; Joint Photographic Experts Group", "*.png ; Portable Network Graphics", "*.tga ; Truevision Graphics Adapter"]))
	
func create_shared_colored_controls():
	shared_color_controls_vbox = create_vbox(5)
	set_shared_color_option_button()
	shared_color_path_line_edit = create_path_line_edit("Image Path")
	shared_color_texture_rect = create_texture_rect(100,100)
	shared_color_browse_button = create_small_button()
	shared_color_browse_button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Folder.svg")
	shared_color_browse_button.pressed.connect(_on_shared_color_browse_pressed)
	shared_color_browse_file_dialog = create_file_dialog("Image File")
	shared_color_browse_file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	shared_color_browse_file_dialog.file_selected.connect(_on_shared_color_file_selected)
	shared_color_browse_file_dialog.clear_filters()
	shared_color_browse_file_dialog.set_filters(PackedStringArray(["*.bmp ; Bitmap Images","*.jpg ; Joint Photographic Experts Group", "*.png ; Portable Network Graphics", "*.tga ; Truevision Graphics Adapter"]))
	
func parent_image_controls():
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hbox.add_child(image_path_line_edit)
	inner_hbox.add_child(image_browse_button)
	inner_hbox.add_child(image_browse_file_dialog)
	vbox.add_child(create_label("Overlay Image"))
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(image_texture_rect)
	image_controls_vbox.add_child(hbox)
	
func parent_dynamic_controls():
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	var inner_hbox2: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hbox.add_child(dynamic_path_line_edit)
	inner_hbox.add_child(dynamic_browse_button)
	inner_hbox.add_child(dynamic_browse_file_dialog)
	inner_hbox2.add_child(create_label("Dynamic Color"))
	inner_hbox2.add_child(dynamic_color_picker_button)
	vbox.add_child(inner_hbox2)
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(dynamic_texture_rect)
	dynamic_controls_vbox.add_child(hbox)
	
func parent_shared_colored_controls():
	var hbox: HBoxContainer = create_hbox(5)
	var vbox: VBoxContainer = create_vbox(5)
	var inner_hbox: HBoxContainer = create_hbox(5)
	var inner_hbox2: HBoxContainer = create_hbox(5)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	inner_hbox.add_child(shared_color_path_line_edit)
	inner_hbox.add_child(shared_color_browse_button)
	inner_hbox.add_child(shared_color_browse_file_dialog)
	inner_hbox2.add_child(create_label("Shared Color"))
	inner_hbox2.add_child(shared_color_option_button)
	vbox.add_child(inner_hbox2)
	vbox.add_child(inner_hbox)
	hbox.add_child(vbox)
	hbox.add_child(shared_color_texture_rect)
	shared_color_controls_vbox.add_child(hbox)
	
func set_shared_color_option_button():
	shared_color_option_button = OptionButton.new()
	shared_color_option_button.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	shared_color_option_button.clear()
	for color in colors_dictionary:
		shared_color_option_button.add_item(color)
	shared_color_option_button.selected = -1
	shared_color_option_button.item_selected.connect(_on_shared_color_changed)

func reset_controls():
	image_path_line_edit.text = ""
	dynamic_path_line_edit.text = ""
	shared_color_path_line_edit.text = ""
	set_shared_color_option_button()
	dynamic_color_picker_button.color = Color(0,0,0,1)
	image_texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
	dynamic_texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
	shared_color_texture_rect.set_texture(AWOCImageControl.load_image("res://addons/awoc/images/no_image.png"))
	image_controls_vbox.visible = false
	dynamic_controls_vbox.visible = false
	shared_color_controls_vbox.visible = false
	
func _on_shared_color_changed(index: int):
	shared_color_option_button.selected = index
	validate_inputs()
			
func _on_image_browse_pressed():
	image_browse_file_dialog.visible = true
	
func _on_dynamic_browse_pressed():
	dynamic_browse_file_dialog.visible = true
	
func _on_shared_color_browse_pressed():
	shared_color_browse_file_dialog.visible = true
			
func _on_image_file_selected(path: String):
	image_path_line_edit.text = path
	image_texture_rect.texture = AWOCImageControl.load_image(path)
	validate_inputs()
	
func _on_dynamic_file_selected(path: String):
	dynamic_path_line_edit.text = path
	dynamic_texture_rect.texture = AWOCImageControl.load_image(path)
	validate_inputs()
	
func _on_shared_color_file_selected(path: String):
	shared_color_path_line_edit.text = path
	shared_color_texture_rect.texture = AWOCImageControl.load_image(path)
	validate_inputs()

func create_controls():
	create_image_controls()
	create_dynamic_controls()
	create_shared_colored_controls()
	
func parent_controls():
	super()
	parent_image_controls()
	parent_dynamic_controls()
	parent_shared_colored_controls()

func _init(i_name: String, c_dictionary: Dictionary):
	image_name = i_name
	colors_dictionary = c_dictionary
	super()

static func load_image(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print(str("Could not load image at: ",path))
		return
	return load(path)
