@tool
class_name AWOCTabBase extends AWOCControlBase

var new_resource_control: AWOCNewResourceControlBase
var manage_resources_control: AWOCManageResourcesControlBase

func reset_controls():
	new_resource_control.reset_controls()
	manage_resources_control.reset_controls()

func reset_tab():
	reset_controls()
	new_resource_control.hide_control_panel_container()
	manage_resources_control.hide_control_panel_container()

func set_tab_listeners():
	new_resource_control.show_control.connect(manage_resources_control.hide_control_panel_container)
	manage_resources_control.show_control.connect(new_resource_control.hide_control_panel_container)
	new_resource_control.control_reset.connect(reset_controls)
	manage_resources_control.control_reset.connect(reset_controls)

func create_controls():
	main_panel_container = PanelContainer.new()
	
func parent_controls():
	var vbox = create_vbox(10)
	vbox.add_child(new_resource_control.main_panel_container)
	vbox.add_child(manage_resources_control.main_panel_container)
	main_panel_container.add_child(vbox)
	
func _init():
	super()
	set_tab_listeners()
