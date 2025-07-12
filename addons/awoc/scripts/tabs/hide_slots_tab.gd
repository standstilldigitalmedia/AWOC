@tool
class_name AWOCHideSlotsTab extends AWOCTabBase

signal control_reset()

var awoc_resource_controller: AWOCResourceController
var hide_slots_array: Array[String]
var slot_name: String

func reset_controls():
	new_resource_control.hide_slots_array = hide_slots_array
	manage_resources_control.hide_slots_array = hide_slots_array
	new_resource_control.reset_controls()
	manage_resources_control.reset_controls()

func emit_control_reset():
	control_reset.emit()

func _init(a_resource_controller: AWOCResourceController, hs_array: Array[String], s_name: String):
	awoc_resource_controller = a_resource_controller
	hide_slots_array = hs_array
	slot_name = s_name
	new_resource_control = AWOCNewHideSlotControl.new(awoc_resource_controller, hide_slots_array, slot_name)
	manage_resources_control = AWOCManageHideSlotsControl.new(hide_slots_array)
	new_resource_control.controls_reset.connect(emit_control_reset)
	manage_resources_control.controls_reset.connect(emit_control_reset)
	super()
