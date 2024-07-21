@tool
class_name AWOCHideSlotTab extends AWOCTabBase

var slot_controller: AWOCSlotController

func populate_manage_resources_container():
	super()
	for hide_slot in slot_controller.hide_slot_array:
		var control = AWOCManageHideSlotControl.new(slot_controller, hide_slot)
		manage_resources_inner_vbox.add_child(control.main_panel_container)
		control.resource_deleted.connect(on_resource_deleted)

func reset_tab():
	new_resource_control.reset_inputs()
	populate_manage_resources_container()
	if slot_controller.dictionary.size() > 0:
		new_resource_button.disabled = false
	else:
		new_resource_button.disabled = true
	super()
	
func on_resource_deleted():
	new_resource_control.reset_inputs()
	super()
	
func set_manage_button_disabled():
	if slot_controller.hide_slot_array.size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		manage_resources_panel_container.visible = false
	
func create_new_resource_control():
	new_resource_control = AWOCNewHideSlotControl.new(slot_controller)
	super()

func _init(s_controller: AWOCSlotController):
	slot_controller = s_controller
	super()
