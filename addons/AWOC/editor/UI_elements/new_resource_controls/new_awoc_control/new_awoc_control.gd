@tool
class_name AWOCNewAWOCControl
extends VBoxContainer

@onready var name_line_edit: LineEdit = $GridContainer/NameLineEdit
@onready var asset_path_line_edit: LineEdit = $GridContainer/HBoxContainer/AssetPathLineEdit
@onready var browse_button: Button = $GridContainer/HBoxContainer/BrowseButton
@onready var error_label: Label = $ErrorLabel
@onready var create_button: Button = $CreateButton
@onready var file_dialog: FileDialog = $FileDialog


func set_error(error_message: String = "") -> void:
	if error_message.is_empty():
		error_label.hide()
	else:
		error_label.text = error_message
		error_label.show()
	
	
func validate() -> void:
	create_button.disabled = true
	set_error()
	if !AWOCValidator.is_valid_name(name_line_edit.text):
		set_error("Please enter a valid name for your AWOC")
		return
	if !AWOCValidator.is_valid_directory_path(asset_path_line_edit.text):
		set_error("Please enter a valid path for your AWOC")
		return
	create_button.disabled = false
	
	
func reset_inputs() -> void:
	name_line_edit.text = ""
	asset_path_line_edit.text = ""
	create_button.disabled = true


func _on_create_button_pressed() -> void:
	var signal_data := {
		"type": "awoc",
		"name": name_line_edit.text, 
		"path": asset_path_line_edit.text
	}
	SignalBus.create_new_resource_requested.emit(signal_data)
	reset_inputs()


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate()


func _on_asset_path_line_edit_text_changed(new_text: String) -> void:
	validate()


func _on_browse_button_pressed() -> void:
	browse_button.disabled = true
	file_dialog.show()


func _on_file_dialog_dir_selected(dir: String) -> void:
	browse_button.disabled = false
	asset_path_line_edit.text = dir
	validate()
	
	
func _on_file_dialog_canceled() -> void:
	browse_button.disabled = false	
	
	
func _ready() -> void:
	error_label.hide()
	create_button.disabled = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_RESOURCES
