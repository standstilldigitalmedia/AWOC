@tool
class_name AWOCNewMeshControl
extends AWOCNewControlBase


signal new_resource(path: String, single_mesh: bool)

var _multi_mesh_line_edit: LineEdit
var _single_mesh_line_edit: LineEdit
var _create_new_mesh_button: Button


func _create_controls() -> void:
	_multi_mesh_line_edit = create_multi_mesh_line_edit()
	_single_mesh_line_edit = create_single_mesh_line_edit()
	_create_new_mesh_button = create_text_button("Add Mesh(es)")
	_create_new_mesh_button.disabled = true
	
	
func on_file_selected(path: String) -> void:
	_multi_mesh_line_edit.text = path
	validate_inputs()
	
	
func _on_browse_button_pressed() -> void:
	var browse_dialog: FileDialog = create_file_browse_file_dialog("Avatar File")
	browse_dialog.file_selected.connect(on_file_selected)
	browse_dialog.visible = true
	browse_dialog.clear_filters()
	browse_dialog.add_filter("*.glb", "GL Transmission Format Binary file")
	add_child(browse_dialog)
	
	
func _parent_controls() -> void:
	var vbox: VBoxContainer = create_vbox(10)
	var hbox: HBoxContainer = create_hbox(10)
	var browse_button: Button = create_icon_button(AWOCGlobal.BROWSE_ICON)
	browse_button.pressed.connect(_on_browse_button_pressed)
	hbox.add_child(_multi_mesh_line_edit)
	hbox.add_child(browse_button)
	vbox.add_child(hbox)
	vbox.add_child(_single_mesh_line_edit)
	vbox.add_child(_create_new_mesh_button)
	add_child(vbox)
	

func _set_listeners() -> void:
	_multi_mesh_line_edit.text_changed.connect(_on_line_edit_text_changed)
	_single_mesh_line_edit.text_changed.connect(_on_line_edit_text_changed)
	_create_new_mesh_button.pressed.connect(_on_create_new_slot_button_pressed)
	
	
func _on_create_new_slot_button_pressed() -> void:
	if AWOCGlobal.is_avatar_file(_multi_mesh_line_edit.text) and _multi_mesh_line_edit.text != "":
		new_resource.emit(_multi_mesh_line_edit.text, false)
	elif AWOCGlobal.is_valid_path(_single_mesh_line_edit.text) and _single_mesh_line_edit.text != "":
		new_resource.emit(_single_mesh_line_edit.text, true)
	reset_inputs()
	

func _on_line_edit_text_changed(new_text: String) -> void:
	validate_inputs()
	
		
func reset_inputs() -> void:
	_multi_mesh_line_edit.text = ""
	_single_mesh_line_edit.text = ""
	_create_new_mesh_button.disabled = true
	
	
func validate_inputs() -> void:
	if AWOCGlobal.is_avatar_file(_multi_mesh_line_edit.text) and _multi_mesh_line_edit.text != "":
		_create_new_mesh_button.disabled = false
		return
	if AWOCGlobal.is_valid_path(_single_mesh_line_edit.text) and _single_mesh_line_edit.text != "":
		_create_new_mesh_button.disabled = false
		return
	_create_new_mesh_button.disabled = true
