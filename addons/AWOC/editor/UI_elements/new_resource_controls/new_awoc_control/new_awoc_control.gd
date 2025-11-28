@tool
class_name AWOCNewAWOCControl
extends AWOCNewResourceControlBase

@export var name_line_edit: LineEdit
@export var asset_path_line_edit: LineEdit
@export var browse_button: Button
@export var create_button: Button
@export var file_dialog: FileDialog


func disable_inputs(disable: bool) -> void:
	name_line_edit.editable = !disable
	asset_path_line_edit.editable = !disable
	browse_button.disabled = disable
	create_button.disabled = disable


func reset_inputs() -> void:
	name_line_edit.text = ""
	asset_path_line_edit.text = ""
	create_button.disabled = true
	browse_button.disabled = false


func validate() -> void:
	var name_is_valid = AWOCValidator.is_valid_name(name_line_edit.text)
	var path_is_valid = AWOCValidator.is_valid_directory_path(asset_path_line_edit.text)
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	var name_exists = awoc_manager.has_named_resource(AWOCResourceType.Type.AWOC, name_line_edit.text)
	if not name_is_valid:
		set_error("Please enter a valid name for your AWOC")
	elif name_exists:
		set_error("An AWOC with that name already exists")
	elif not path_is_valid:
		set_error("Please enter a valid path for your AWOC")
	else:
		set_error()
	create_button.disabled = not (name_is_valid and path_is_valid)


func _on_create_button_pressed() -> void:
	disable_inputs(true)
	var additional_data := {"path": asset_path_line_edit.text}
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if !signal_bus:
		disable_inputs(false)
		return
	signal_bus.create_new_resource_requested.emit(AWOCResourceType.Type.AWOC, name_line_edit.text, additional_data)


func _on_name_line_edit_text_changed(_new_text: String) -> void:
	validate()


func _on_asset_path_line_edit_text_changed(_new_text: String) -> void:
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


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		modified_resource("New AWOC Created Successfully", result)
		

func _ready() -> void:
	create_button.disabled = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	super._ready()
