@tool
class_name AWOCControlBase extends Node

const NAME_MIN_CHAR = 4

var resource_controller: AWOCResourceControllerBase
var main_panel_container: PanelContainer
const image_base_dir: String = "res://addons/awoc/images/godot_icons/"

func is_valid_name(name: String) -> bool:
	if name.length() < NAME_MIN_CHAR:
		return false
	if !name.is_valid_filename():
		return false
	return true
	
func create_line_edit(placeholder: String) -> LineEdit:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	line_edit.placeholder_text = placeholder
	return line_edit
	
func create_small_button() -> Button:
	var button: Button = Button.new()
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.custom_minimum_size.x = 31
	button.custom_minimum_size.y = 31
	return button
	
func create_add_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "Add.svg")
	return button
	
func create_browse_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "Folder.svg")
	return button
	
func create_rename_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "Save.svg")
	return button
	
func create_delete_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "Remove.svg")
	return button
	
func create_edit_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "Edit.svg")
	return button
	
func create_show_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "GuiVisibilityVisible.svg")
	return button
	
func create_hide_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(image_base_dir + "GuiVisibilityHidden.svg")
	return button
	
func create_vbox(seperation: int) -> VBoxContainer:
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", seperation)
	return vbox
	
func create_hbox(seperation: int) -> HBoxContainer:
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", seperation)
	return hbox
	
func create_margin_container(top: int, left: int, bottom: int, right: int) -> MarginContainer:
	var margin_container: MarginContainer = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", top)
	margin_container.add_theme_constant_override("margin_left", left)
	margin_container.add_theme_constant_override("margin_bottom", bottom)
	margin_container.add_theme_constant_override("margin_right", right)
	return margin_container
	
func create_file_dialog(title: String) -> FileDialog:
	var file_dialog: FileDialog = FileDialog.new()
	file_dialog.title = title
	file_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	file_dialog.set_current_dir("res://")
	file_dialog.set_initial_position(FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	file_dialog.size.x = 400
	file_dialog.size.y = 300
	file_dialog.visible = false
	return file_dialog
	
func create_path_browse_file_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_DIR)
	#file_dialog.clear_filters()
	#file_dialog.set_filters(PackedStringArray(["*.png ; PNG Images","*.gd ; GDScript Files"]))
	return file_dialog
	
func create_label(text: String) -> Label:
	var label = Label.new()
	label.text = text
	#label.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	return label
	
func create_panel_container(r: float, g: float, b: float, a: float) -> PanelContainer:
	var panel_container: PanelContainer = PanelContainer.new()
	var panel_styleBox: StyleBoxFlat = panel_container.get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	panel_container.add_theme_stylebox_override("panel", panel_styleBox)
	panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	panel_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return panel_container
	
func create_confirmation_dialog(title: String, text: String) -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = ConfirmationDialog.new()
	confirmation_dialog.title = title
	confirmation_dialog.dialog_text = text
	confirmation_dialog.set_initial_position(FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	return confirmation_dialog
	
func create_rename_confirmation_dialog() -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = create_confirmation_dialog("Rename " + resource_controller.name + "?", "Are you sure you wish to rename " + resource_controller.name + "? This can not be undone.")
	return confirmation_dialog
	
func create_delete_confirmation_dialog() -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = create_confirmation_dialog("Delete " + resource_controller.name + "?", "Are you sure you wish to delete " + resource_controller.name + "? This can not be undone.")
	return confirmation_dialog
	
func create_scroll_container() -> ScrollContainer:
	var scroll_container: ScrollContainer = ScrollContainer.new()
	scroll_container.custom_minimum_size = Vector2(0,300)
	scroll_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	scroll_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return scroll_container

func _init(r_controller: AWOCResourceControllerBase):
	resource_controller = r_controller
