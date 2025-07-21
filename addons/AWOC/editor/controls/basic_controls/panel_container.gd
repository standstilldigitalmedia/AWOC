@tool
class_name AWOCPanelContainer
extends PanelContainer


func _init(is_transparent: bool) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if is_transparent:
		set_bg_color(0,0,0,0)
	else:
		set_bg_color(1,1,1,0.1)
	

func set_bg_color(r: float, g: float, b: float, a: float) -> void:
	var panel_styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	add_theme_stylebox_override("panel", panel_styleBox)
	
