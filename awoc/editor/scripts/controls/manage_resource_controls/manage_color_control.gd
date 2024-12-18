@tool
class_name AWOCManageColorControl
extends AWOCManageControlBase
	
signal color_updated(color_name: String, color: Color)

var _color_picker_button: ColorPickerButton

	
func _on_color_changed(new_color: Color):
	color_updated.emit(_resource_name, new_color)
	
	
func _create_controls() -> void:
	super()
	_name_line_edit = create_line_edit("Color Name", _resource_name)
	_color_picker_button = create_color_picker_button()
	_color_picker_button.color_changed.connect(_on_color_changed)
	
	
func _parent_controls() -> void:
	super()
	_controls_hbox.add_child(_name_line_edit)
	_controls_hbox.add_child(_rename_button)
	_controls_hbox.add_child(_delete_button)
	_controls_hbox.add_child(_color_picker_button)
