@tool
class_name AWOCMarginContainer
extends MarginContainer


func _init(top: int, left: int, bottom: int, right: int) -> void:
	add_theme_constant_override("margin_top", top)
	add_theme_constant_override("margin_left", left)
	add_theme_constant_override("margin_bottom", bottom)
	add_theme_constant_override("margin_right", right)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
