@tool
class_name AWOCColorPickerButton extends ColorPickerButton

signal color_update(overlay_name, new_color: Color, shared_color_name: String)

var overlay_name: String
var shared_color_name: String

func _on_color_changed(new_color: Color):
	color = new_color
	color_update.emit(overlay_name, new_color, shared_color_name)

func _init(o_name: String, s_color_name: String):
	overlay_name = o_name
	shared_color_name = s_color_name
	color_changed.connect(_on_color_changed)
	custom_minimum_size = Vector2(31,31)
	size.x = 31
	size.y = 31
