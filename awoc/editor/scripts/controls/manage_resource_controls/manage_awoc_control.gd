@tool
class_name AWOCManageAWOCControl
extends AWOCManageControlBase

signal resource_edited(resource_name: String)

var _edit_button: Button
	

func _create_controls() -> void:
	super()
	_name_line_edit = create_line_edit("AWOC Name", _resource_name)
	_edit_button = create_icon_button(AWOCGlobal.EDIT_ICON)
	
	
func _parent_controls() -> void:
	super()
	_controls_hbox.add_child(_name_line_edit)
	_controls_hbox.add_child(_rename_button)
	_controls_hbox.add_child(_delete_button)
	_controls_hbox.add_child(_edit_button)
	
func _set_listeners() -> void:
	_edit_button.pressed.connect(_on_edit_button_pressed)
	super()
	
	
func _on_edit_button_pressed() -> void:
	resource_edited.emit(_resource_name)
