@tool
class_name AWOCControlBase extends PanelContainer

signal controls_reset()

static func is_valid_path(path: String) -> bool:
	var dir = DirAccess.open(path)
	if dir:
		return true
	return false
	
static func is_avatar_file(path: String) -> bool:
	var file_path = path.get_base_dir()
	var file_name = path.get_file()
	if !is_valid_path(file_path):
		return false
	if file_name:
		var name_split: PackedStringArray = file_name.split(".")
		if name_split.size() > 1:
			if name_split[1] == "glb":
				if FileAccess.file_exists(path):
					return true
	return false
	
static func is_image_file(path: String) -> bool:
	var file_name = path.get_file()
	if file_name:
		var name_split: PackedStringArray = file_name.split(".")
		if name_split.size() > 1:
			if name_split[1] == "bmp" or name_split[1] == "jpg" or name_split[1] == "png" or name_split[1] == "tga":
				if FileAccess.file_exists(path):
					return true
	return false
	
func is_valid_name(name: String) -> bool:
	if name.length() < AWOCPlugin.NAME_MIN_CHAR:
		return false
	if !name.is_valid_filename():
		return false
	return true

func reset_controls():
	pass

func validate_inputs():
	pass
	
func _on_add_button_pressed():
	pass
	
func _on_add_new_resource_button_pressed():
	pass
	
func _on_browse_button_pressed():
	pass
	
func _on_color_picker_color_change(new_color: Color):
	pass
	
func _on_delete_button_pressed():
	pass
	
func _on_delete_confirmed():
	pass
	
func _on_edit_button_pressed():
	pass
	
func _on_file_selected(path: String):
	pass
	
func _on_hide_button_pressed():
	pass
	
func _on_manage_resources_button_toggled(toggled_on: bool):
	pass
	
func _on_multi_mesh_line_edit_text_changed(new_text: String):
	pass

func _on_name_line_edit_text_changed(new_text: String):
	pass
	
func _on_new_resource_toggle_button_toggled(toggled_on: bool):
	pass

func _on_path_line_edit_text_changed(new_text: String):
	pass
	
func _on_path_selected(dir: String):
	pass
	
func _on_rename_button_pressed():
	pass
	
func _on_rename_confirmed():
	pass
	
func _on_single_mesh_line_edit_text_changed(new_text: String):
	pass
	
func _on_show_button_pressed():
	pass

func _on_tab_selected(index: int):
	pass	

func create_add_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Add.svg")
	button.pressed.connect(_on_add_button_pressed)
	button.disabled = true
	return button	

func create_add_new_resource_button(button_text: String) -> Button:
	var button = Button.new()
	button.text = button_text
	button.disabled = true
	button.pressed.connect(_on_add_new_resource_button_pressed)
	return button	
	
func create_browse_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Folder.svg")
	button.pressed.connect(_on_browse_button_pressed)
	return button
	
func create_no_listener_color_picker_button() -> ColorPickerButton:
	var button: ColorPickerButton = ColorPickerButton.new()
	button.color = Color(0.0,0.0,0.0,1.0)
	button.custom_minimum_size.x = 31
	button.custom_minimum_size.y = 31
	return button
	
func create_color_picker_button() -> ColorPickerButton:
	var button: ColorPickerButton = create_no_listener_color_picker_button()
	button.color_changed.connect(_on_color_picker_color_change)
	return button
	
func create_confirmation_dialog(title: String, text: String) -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = ConfirmationDialog.new()
	confirmation_dialog.title = title
	confirmation_dialog.dialog_text = text
	confirmation_dialog.set_initial_position(FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	confirmation_dialog.visible = false
	return confirmation_dialog

func create_delete_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Remove.svg")
	button.pressed.connect(_on_delete_button_pressed)
	return button
	
func create_delete_confirmation_dialog(r_name: String) -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = create_confirmation_dialog("Delete " + r_name + "?", "Are you sure you wish to delete " + r_name + "? This can not be undone.")
	confirmation_dialog.confirmed.connect(_on_delete_confirmed)
	return confirmation_dialog
	
func create_edit_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Edit.svg")
	button.pressed.connect(_on_edit_button_pressed)
	return button
	
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
	
func create_file_open_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	file_dialog.file_selected.connect(_on_file_selected)
	return file_dialog
	
func create_grid_container() -> GridContainer:
	var container: GridContainer = GridContainer.new()
	container.columns = 3
	return container
	
func create_hbox(seperation: int) -> HBoxContainer:
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", seperation)
	return hbox
	
func create_hide_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "GuiVisibilityHidden.svg")
	button.pressed.connect(_on_hide_button_pressed)
	return button
	
func create_label(text: String) -> Label:
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return label
	
func create_line_edit(placeholder: String, text: String = "") -> LineEdit:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	line_edit.text = text
	line_edit.placeholder_text = placeholder
	return line_edit
	
func create_manage_resources_toggle_button(button_text: String) -> Button:
	var button = create_toggle_button(button_text)
	button.toggled.connect(_on_manage_resources_button_toggled)
	return button
	
func create_multi_mesh_line_edit() -> LineEdit:
	var line_edit = create_line_edit("Avatar File", "")
	line_edit.set_script(load("res://addons/awoc/scripts/control_overrides/multiple_mesh_control_override.gd"))
	line_edit.text_changed.connect(_on_multi_mesh_line_edit_text_changed)
	return line_edit
	
func create_new_resource_toggle_button(button_text: String) -> Button:
	var button = create_toggle_button(button_text)
	button.toggled.connect(_on_new_resource_toggle_button_toggled)
	return button
	
func create_option_button() -> OptionButton:
	var option_button: OptionButton = OptionButton.new()
	option_button.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return option_button
	
func create_path_browse_file_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_DIR)
	file_dialog.dir_selected.connect(_on_path_selected)
	return file_dialog
	
func create_path_line_edit(placeholder: String, text: String = "") -> LineEdit:
	var line_edit = create_line_edit(placeholder, text)
	line_edit.text_changed.connect(_on_path_line_edit_text_changed)
	return line_edit
	
func create_margin_container(top: int, left: int, bottom: int, right: int) -> MarginContainer:
	var margin_container: MarginContainer = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", top)
	margin_container.add_theme_constant_override("margin_left", left)
	margin_container.add_theme_constant_override("margin_bottom", bottom)
	margin_container.add_theme_constant_override("margin_right", right)
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	margin_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return margin_container
	
func create_name_line_edit(placeholder: String, text: String = "") -> LineEdit:
	var line_edit = create_line_edit(placeholder, text)
	line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	return line_edit
	
func create_panel_container(r: float, g: float, b: float, a: float) -> PanelContainer:
	var panel_container: PanelContainer = PanelContainer.new()
	var panel_styleBox: StyleBoxFlat = panel_container.get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	panel_container.add_theme_stylebox_override("panel", panel_styleBox)
	panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	panel_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return panel_container
	
func create_rename_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Save.svg")
	button.pressed.connect(_on_rename_button_pressed)
	return button
	
func create_rename_confirmation_dialog(r_name: String) -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = create_confirmation_dialog("Rename " + r_name + "?", "Are you sure you wish to rename " + r_name + "? This can not be undone.")
	confirmation_dialog.confirmed.connect(_on_rename_confirmed)
	return confirmation_dialog
	
func create_scroll_container() -> ScrollContainer:
	var scroll_container: ScrollContainer = ScrollContainer.new()
	scroll_container.custom_minimum_size = Vector2(0,300)
	scroll_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	scroll_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return scroll_container
	
func create_show_button() -> Button:
	var button: Button = create_small_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "GuiVisibilityVisible.svg")
	button.pressed.connect(_on_show_button_pressed)
	return button
	
func create_simi_transparent_panel_container():
	return create_panel_container(1.0,1.0,1.0,0.05)
	
func create_single_mesh_line_edit() -> LineEdit:
	var line_edit = create_line_edit("Single Mesh Node", "")
	line_edit.set_script(load("res://addons/awoc/scripts/control_overrides/single_mesh_control_override.gd"))
	line_edit.text_changed.connect(_on_single_mesh_line_edit_text_changed)
	return line_edit
	
func create_small_button() -> Button:
	var button: Button = Button.new()
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.custom_minimum_size.x = 31
	button.custom_minimum_size.y = 31
	return button
	
func create_tab_container() -> TabContainer:
	var tab_container: TabContainer = TabContainer.new()
	tab_container.tab_selected.connect(_on_tab_selected)
	return tab_container
	
func create_texture_rect(width: int, height: int) -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(width,height)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	return texture_rect

func create_toggle_button(button_text: String) -> Button:
	var button: Button = Button.new()
	button.text = button_text
	button.toggle_mode = true
	return button
	
func create_transparent_panel_container():
	return create_panel_container(0.0,0.0,0.0,0.0)
	
func create_vbox(seperation: int) -> VBoxContainer:
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", seperation)
	return vbox
	
func set_panel_container(r: float, g: float, b: float, a: float):
	var panel_styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	add_theme_stylebox_override("panel", panel_styleBox)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	
func set_transparent_panel_container():
	set_panel_container(0.0,0.0,0.0,0.0)
	
func set_simi_transparent_panel_container():
	set_panel_container(1.0,1.0,1.0,0.05)
	
func create_controls():
	pass
	
func parent_controls():
	pass
	
func _init():
	create_controls()
	parent_controls()
