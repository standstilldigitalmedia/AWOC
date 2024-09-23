@tool
class_name AWOCManageSlotsControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController

func populate_resource_controls_area():
	super()
	for slot_name in awoc_resource_controller.get_slots_dictionary():
		var slot_control = AWOCSlotControl.new(awoc_resource_controller, slot_name)
		slot_control.controls_reset.connect(emit_controls_reset)
		control_panel_container_vbox.add_child(slot_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Slots")
	super()
	
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super(awoc_resource_controller.get_slots_dictionary())
