@tool
class_name AWOCResourceControlBase
extends AWOCControlBase


func create_color_picker_button() -> ColorPickerButton:
	var color_picker_button: ColorPickerButton = ColorPickerButton.new()
	color_picker_button.custom_minimum_size.x = 31
	return color_picker_button
	

func create_file_browse_file_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	return file_dialog
	
		
func create_file_dialog(title: String) -> FileDialog:
	var file_dialog: FileDialog = FileDialog.new()
	file_dialog.title = title
	file_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	file_dialog.set_current_dir("res://")
	file_dialog.set_initial_position(
			FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	file_dialog.size.x = 400
	file_dialog.size.y = 300
	file_dialog.visible = false
	return file_dialog
	

func create_file_open_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	return file_dialog

	
func create_icon_button(icon: Texture2D) -> Button:
	var button = Button.new()
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.custom_minimum_size.x = 31
	button.custom_minimum_size.y = 31
	button.icon = icon
	return button
	
	
func create_line_edit(placeholder_text: String, text: String = "") -> LineEdit:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.placeholder_text = placeholder_text
	line_edit.text = text
	line_edit.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return line_edit
	
	
func create_path_browse_file_dialog(title: String) -> FileDialog:
	var file_dialog = create_file_dialog(title)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_DIR)
	return file_dialog
