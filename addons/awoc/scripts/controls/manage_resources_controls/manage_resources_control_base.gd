@tool
class_name AWOCManageResourcesControlBase extends AWOCTabControlBase

var dictionary: Dictionary

func emit_controls_reset():
	controls_reset.emit()

func populate_resource_controls_area():
	for child in control_panel_container_vbox.get_children():
		child.queue_free()

func set_tab_button_disabled():
	if dictionary.size() > 0:
		tab_button.disabled = false
	else:
		tab_button.disabled = true
		hide_control_panel_container()
		
func reset_controls():
	populate_resource_controls_area()
	set_tab_button_disabled()

func _on_manage_resources_button_toggled(toggled_on: bool):
	if toggled_on:
		show_control_panel_container()
	else: 
		hide_control_panel_container()
		
func _init(dict: Dictionary):
	dictionary = dict
	super()
