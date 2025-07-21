@tool
class_name AWOCMeshFileBrowser
extends AWOCHBox

signal validated(validated: bool)

var path_line_edit: AWOCLineEdit
var browse_button: AWOCFolderIconButton
var path_browse_dialog: AWOCFileBrowseDialog


func reset_controls() -> void:
	path_line_edit.text = ""
	path_browse_dialog.visible = false
	
	
func validate() -> void:
	if AWOCGlobal.is_avatar_file(path_line_edit.text):
		validated.emit(true)
	else:
		validated.emit(false)
		
		
func get_asset_path() -> String:
	return path_line_edit.text
	
	
func _init(title: String, dialog_type: String = "") -> void:
	super(5)
	path_line_edit = AWOCLineEdit.new(title)
	browse_button = AWOCFolderIconButton.new()
	path_browse_dialog = AWOCFileBrowseDialog.new(title)
	path_browse_dialog.clear_filters()
	path_line_edit.set_script(load(AWOCGlobal.MULTI_MESH_CONTROL_OVERRIDE_PATH))
	
	path_line_edit.text_changed.connect(_on_path_line_edit_text_changed)
	browse_button.pressed.connect(_on_browse_button_pressed)
	path_browse_dialog.file_selected.connect(_on_file_selected)
	add_child(path_line_edit)
	add_child(browse_button)
	add_child(path_browse_dialog)
	

func _on_path_line_edit_text_changed(new_text: String) -> void:
	validate()
	
	
func _on_browse_button_pressed() -> void:
	path_browse_dialog.visible = true
	
	
func _on_file_selected(path: String) -> void:
	path_line_edit.text = path
	validate()
