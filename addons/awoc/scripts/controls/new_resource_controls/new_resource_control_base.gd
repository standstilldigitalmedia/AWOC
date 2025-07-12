@tool
class_name AWOCNewResourceControlBase extends AWOCTabControlBase

func _on_new_resource_toggle_button_toggled(toggled_on: bool):
	if toggled_on:
		show_control_panel_container()
	else: 
		hide_control_panel_container()
	
