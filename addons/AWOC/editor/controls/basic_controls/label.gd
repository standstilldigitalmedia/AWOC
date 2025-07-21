@tool
class_name AWOCLabel
extends Label

func _init(label_text: String) -> void:
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = label_text
	
	
func set_align_left() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	
func set_align_right() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	
func set_align_top() -> void:
	vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	
func set_align_bottom() -> void:
	vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
