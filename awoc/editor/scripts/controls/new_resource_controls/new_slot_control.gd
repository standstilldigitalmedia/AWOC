@tool
class_name AWOCNewSlotControl
extends AWOCNewControlBase

signal new_resource(slot_name: String)

var _name_line_edit: LineEdit
var _create_new_slot_button: Button


func _create_controls() -> void:
	_name_line_edit = create_line_edit("Slot Name")
	_create_new_slot_button = create_text_button("Create Slot")
	_create_new_slot_button.disabled = true
	
	
func _parent_controls() -> void:
	var vbox: VBoxContainer = create_vbox(10)
	vbox.add_child(_name_line_edit)
	vbox.add_child(_create_new_slot_button)
	add_child(vbox)
	

func _set_listeners() -> void:
	_name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	_create_new_slot_button.pressed.connect(_on_create_new_slot_button_pressed)
	
	
func _on_create_new_slot_button_pressed() -> void:
	new_resource.emit(_name_line_edit.text)
	reset_inputs()
	

func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate_inputs()
	
		
func reset_inputs() -> void:
	_name_line_edit.text = ""
	_create_new_slot_button.disabled = true
	
	
func validate_inputs() -> void:
	if !AWOCGlobal.is_valid_name(_name_line_edit.text):
		_create_new_slot_button.disabled = true
		return
	_create_new_slot_button.disabled = false
	
