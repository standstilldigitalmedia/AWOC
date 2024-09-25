@tool
class_name AWOCManageHideSlotsControl extends AWOCManageResourcesControlBase

var hide_slots_array: Array[String]

func set_tab_button_disabled():
	if hide_slots_array.size() > 0:
		tab_button.disabled = false
	else:
		tab_button.disabled = true
		hide_control_panel_container()

func populate_resource_controls_area():
	super()
	for a in hide_slots_array.size():
		var hide_slots_control = AWOCHideSlotControl.new(hide_slots_array[a], hide_slots_array)
		hide_slots_control.controls_reset.connect(emit_controls_reset)
		control_panel_container_vbox.add_child(hide_slots_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Hide Slots")
	super()
	
func _init(hs_array: Array[String]):
	hide_slots_array = hs_array
	super({})
