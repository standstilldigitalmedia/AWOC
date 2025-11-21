@tool
class_name AWOCNewAWOCControl
extends AWOCNewResourceControlBase

@onready var name_line_edit: LineEdit = $GridContainer/NameLineEdit
@onready var asset_path_line_edit: LineEdit = $GridContainer/HBoxContainer/AssetPathLineEdit
@onready var browse_button: Button = $GridContainer/HBoxContainer/BrowseButton
@onready var create_button: Button = $CreateButton
@onready var file_dialog: FileDialog = $FileDialog


func validate() -> void:
	var name_is_valid = AWOCValidator.is_valid_name(name_line_edit.text)
	var path_is_valid = AWOCValidator.is_valid_directory_path(asset_path_line_edit.text)
	var name_exists = AWOCManager.awoc_exists(name_line_edit.text)
	if not name_is_valid: 
		set_error("Please enter a valid name for your AWOC")
	elif name_exists:
		set_error("An AWOC with that name already exists")
	elif not path_is_valid: 
		set_error("Please enter a valid path for your AWOC")
	else: set_error() 
	create_button.disabled = not (name_is_valid and path_is_valid)


func reset_inputs() -> void:
	name_line_edit.text = ""
	asset_path_line_edit.text = ""
	create_button.disabled = true
	
	
func _on_create_button_pressed() -> void:
	var additional_data := {
		"path": asset_path_line_edit.text
	}
	SignalBus.create_new_resource_requested.emit(AWOCResourceType.Type.AWOC, name_line_edit.text, additional_data)
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


func _on_new_awoc_created(resource_type: AWOCResourceType.Type, resource_name: String, result: AWOCResourceErrorMessage) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		if result.is_successful():
			set_error("New AWOC Created Successfully")
			reset_inputs()
			await get_tree().create_timer(5.0).timeout
			set_error()
		else:
			set_error(result.error_message)
		

func _ready() -> void:
	set_error()
	create_button.disabled = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	SignalBus.resource_created.connect(_on_new_awoc_created)
