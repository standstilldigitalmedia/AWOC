@tool
class_name AWOCScrollContainer
extends ScrollContainer


func _init() -> void:
	custom_minimum_size = Vector2(0,300)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
