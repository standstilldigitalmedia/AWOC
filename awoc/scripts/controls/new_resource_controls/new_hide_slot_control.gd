@tool
class_name AWOCNewHideSlotControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var hide_slots_array: Array[String]
var slot_name: String
var hide_slot_option_button: OptionButton
var create_new_resource_button: Button

func get_available_hide_slots() -> Array[String]:
	var return_array: Array[String]
	for slot in awoc_resource_controller.get_slots_array():
		var found: bool = false
		if slot.slot_name == slot_name:
			found = true
		else:
			for a in hide_slots_array.size():
				if hide_slots_array[a] == slot.slot_name:
					found = true
					break
		if !found:
			return_array.append(slot.slot_name)
	return return_array

func on_hide_slot_selected(index: int):
	if index != -1:
		create_new_resource_button.disabled = false

func set_tab_button_disabled():
	if get_available_hide_slots().size() < 1:
		tab_button.disabled = true
		hide_control_panel_container()
	elif awoc_resource_controller.get_slots_array().size() > 0:
		tab_button.disabled = false
	else:
		tab_button.disabled = true
		hide_control_panel_container()
	
func populate_option_button():
	var avaliable_slots_array: Array = get_available_hide_slots()
	hide_slot_option_button.clear()
	for slot in avaliable_slots_array:
		hide_slot_option_button.add_item(slot)
	hide_slot_option_button.selected = -1
	if !hide_slot_option_button.item_selected.is_connected(on_hide_slot_selected):
		hide_slot_option_button.item_selected.connect(on_hide_slot_selected)

func reset_controls():
	populate_option_button()
	set_tab_button_disabled()
	create_new_resource_button.disabled = true
	
func _on_add_new_resource_button_pressed():
	hide_slots_array.append(hide_slot_option_button.get_item_text(hide_slot_option_button.selected))
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Hide Slot")
	create_new_resource_button = create_add_new_resource_button("Add Hide Slot")
	hide_slot_option_button = create_option_button()
	super()
	
func parent_controls():
	super()
	control_panel_container_vbox.add_child(hide_slot_option_button)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(a_resource_controller: AWOCResourceController, hs_array: Array[String], s_name: String):
	awoc_resource_controller = a_resource_controller
	hide_slots_array = hs_array
	slot_name = s_name
	super()
	reset_controls()
