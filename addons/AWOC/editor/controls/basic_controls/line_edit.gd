@tool
class_name AWOCLineEdit
extends LineEdit


func _init(placeholder: String, line_text: String = "") -> void:
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	placeholder_text = placeholder
	text = line_text
