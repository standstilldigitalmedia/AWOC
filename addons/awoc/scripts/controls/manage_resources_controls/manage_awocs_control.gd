@tool
class_name AWOCManageAWOCsControl extends AWOCManageResourcesControlBase

signal awoc_edited(awoc_resource_controller: AWOCResourceController)

var awoc_manager_resource_controller: AWOCManagerResourceController

func emit_awoc_edited(awoc_resource_controller: AWOCResourceController):
	awoc_edited.emit(awoc_resource_controller)

func populate_resource_controls_area():
	super()
	for awoc_name in awoc_manager_resource_controller.get_dictionary():
		var awoc_control = AWOCControl.new(awoc_manager_resource_controller, awoc_name)
		awoc_control.controls_reset.connect(emit_controls_reset)
		awoc_control.awoc_edited.connect(emit_awoc_edited)
		control_panel_container_vbox.add_child(awoc_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage AWOCs")
	super()
	
func _init(am_resource_controller: AWOCManagerResourceController):
	awoc_manager_resource_controller = am_resource_controller
	super(am_resource_controller.get_dictionary())
