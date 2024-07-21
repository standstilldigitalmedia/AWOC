@tool
class_name AWOCSlotsTab extends AWOCTabBase

var awoc_resource_controller: AWOCResourceController

func on_resource_renamed():
	super()
	new_resource_control.reset_inputs()
	
func on_resource_deleted():
	super()
	new_resource_control.reset_inputs()
	
func populate_manage_resources_container():
	super()
	for slot in awoc_resource_controller.resource.slots_dictionary:
		var controller: AWOCSlotController = AWOCSlotController.new(slot,awoc_resource_controller.resource)
		var control = AWOCManageSlotControl.new(controller)
		manage_resources_inner_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)

func create_new_resource_control():
	new_resource_control = AWOCNewSlotControl.new(awoc_resource_controller)
	super()
	
func set_manage_button_disabled():
	if awoc_resource_controller.resource.slots_dictionary.size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		manage_resources_panel_container.visible = false
	
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
	populate_manage_resources_container()
