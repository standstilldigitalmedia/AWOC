@tool
class_name AWOCManageColorsControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController

func populate_resource_controls_area():
	super()
	for color_name in awoc_resource_controller.get_colors_dictionary():
		var color_control = AWOCColorControl.new(awoc_resource_controller, color_name, awoc_resource_controller.get_colors_dictionary()[color_name])
		color_control.controls_reset.connect(emit_controls_reset)
		control_panel_container_vbox.add_child(color_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Colors")
	super()
	
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super(awoc_resource_controller.get_colors_dictionary())
