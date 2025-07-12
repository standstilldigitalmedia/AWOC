@tool
class_name AWOCHBox
extends HBoxContainer


func _init(seperation: int) -> void:
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	add_theme_constant_override("separation", seperation)
	
