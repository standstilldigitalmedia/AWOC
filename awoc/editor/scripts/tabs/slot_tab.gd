@tool
class_name AWOCSlotTab
extends AWOCTabBase


func _init(awoc_reference: AWOCEditorResourceReference) -> void:
	_resource_controller = AWOCSlotController.new(awoc_reference)
	super()


func _create_controls() -> void:
	super()
	_new_resource_button = create_toggle_text_button("New Slot")
	_manage_resources_button = create_toggle_text_button("Manage Slots")
	_new_resource_control = AWOCNewSlotControl.new()
	
	
func _set_listeners() -> void:
	super()
	_new_resource_control.new_resource.connect(_on_new_resource)


func _on_new_resource(slot_name: String) -> void:
	_resource_controller.add_new_slot(slot_name)
	set_manage_resources_button_disabled()
	populate_manage_controls()
	

func populate_manage_controls() -> void:
	super()
	for resource_name: String in _resource_controller._get_dictionary():
		var resource_control: AWOCManageSlotControl = AWOCManageSlotControl.new(resource_name)
		add_manage_resource_control_and_set_listeners(resource_control)
