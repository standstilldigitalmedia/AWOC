@tool
class_name AWOCNewAWOCControl
extends AWOCNewControlBase

signal new_resource(name: String, path: String)

var _name_line_edit: LineEdit
var _asset_path_line_edit: LineEdit
var _browse_button: Button
var _browse_dialog: FileDialog
var _create_new_awoc_button: Button

func _create_controls() -> void:
	_name_line_edit = create_line_edit("AWOC Name")
	_asset_path_line_edit = create_line_edit("Asset Creation Path")
	_browse_button = create_icon_button(AWOCGlobal.BROWSE_ICON)
	_browse_dialog = create_path_browse_file_dialog("Asset Creation Path")
	_create_new_awoc_button = create_text_button("Create New AWOC")
	_create_new_awoc_button.disabled = true
	
	
func _parent_controls() -> void:
	var vbox: VBoxContainer = create_vbox(10)
	var hbox: HBoxContainer = create_hbox(5)
	hbox.add_child(_asset_path_line_edit)
	hbox.add_child(_browse_button)
	vbox.add_child(_name_line_edit)
	vbox.add_child(hbox)
	vbox.add_child(_browse_dialog)
	vbox.add_child(_create_new_awoc_button)
	add_child(vbox)
	

func _set_listeners() -> void:
	_name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	_asset_path_line_edit.text_changed.connect(_on_asset_path_line_edit_text_changed)
	_browse_button.pressed.connect(_on_browse_button_pressed)
	_browse_dialog.dir_selected.connect(_on_browse_dialog_dir_selected)
	_create_new_awoc_button.pressed.connect(_on_create_new_awoc_button_pressed)
	
func _on_asset_path_line_edit_text_changed(new_text: String) -> void:
	validate_inputs()
	
	
func _on_browse_button_pressed() -> void:
	_browse_dialog.visible = true
	
	
func _on_browse_dialog_dir_selected(path:String) -> void:
	_asset_path_line_edit.text = path
	validate_inputs()
	
		
func _on_create_new_awoc_button_pressed() -> void:
	new_resource.emit(_name_line_edit.text, _asset_path_line_edit.text)
	reset_inputs()
	

func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate_inputs()
	
		
func reset_inputs() -> void:
	_name_line_edit.text = ""
	_asset_path_line_edit.text = ""
	_asset_path_line_edit.set_script(load("res://addons/awoc/editor/scripts/control_overrides/folder_control_override.gd"))
	_create_new_awoc_button.disabled = true
	_browse_dialog.set_current_dir("res://")
	
	
func validate_inputs() -> void:
	if(!AWOCGlobal.is_valid_name(_name_line_edit.text) 
		or _asset_path_line_edit.text == "" 
		or !DirAccess.open(_asset_path_line_edit.text)
		):
			_create_new_awoc_button.disabled = true
			return
	_create_new_awoc_button.disabled = false
