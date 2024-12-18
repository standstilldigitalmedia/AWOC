@tool
class_name AWOCNewColorControl
extends AWOCNewControlBase

signal new_resource(name: String, color: Color)

var _name_line_edit: LineEdit
var _color_picker_button: ColorPickerButton
var _create_new_color_button: Button


func _create_controls() -> void:
	_name_line_edit = create_line_edit("Color Name")
	_color_picker_button = create_color_picker_button()
	_create_new_color_button = create_text_button("Create Color")
	_create_new_color_button.disabled = true
	
	
func _parent_controls() -> void:
	var vbox: VBoxContainer = create_vbox(10)
	var hbox: HBoxContainer = create_hbox(10)
	hbox.add_child(_name_line_edit)
	hbox.add_child(_color_picker_button)
	vbox.add_child(hbox)
	vbox.add_child(_create_new_color_button)
	add_child(vbox)
	

func _set_listeners() -> void:
	_name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	_create_new_color_button.pressed.connect(_on_create_new_color_button_pressed)
	
	
func _on_create_new_color_button_pressed() -> void:
	new_resource.emit(_name_line_edit.text, _color_picker_button.color)
	reset_inputs()
	

func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate_inputs()
	
		
func reset_inputs() -> void:
	_name_line_edit.text = ""
	_color_picker_button.color = Color(0,0,0,255)
	_create_new_color_button.disabled = true
	
	
func validate_inputs() -> void:
	if !AWOCGlobal.is_valid_name(_name_line_edit.text):
		_create_new_color_button.disabled = true
		return
	_create_new_color_button.disabled = false
	
