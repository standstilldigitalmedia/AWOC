@tool
class_name AWOCNewHideSlotControl extends AWOCNewResourceControlBase

var available_slots_option_button: OptionButton
var add_resource_button: Button
var slot_controller: AWOCResourceControllerBase

func populate_available_slots_option_button():
	available_slots_option_button.clear()
	for slot in slot_controller.resource.hide_slot_dictionary:
		var found: bool = false
		if slot == slot_controller.resource_name:
			found = true
		else:
			for hideslot in slot_controller.hide_slot_array:
				if hideslot == slot:
					found = true
		if !found:
			available_slots_option_button.add_item(slot)
	available_slots_option_button.selected = -1

func reset_inputs():
	populate_available_slots_option_button()
	add_resource_button.disabled = true
		
func _on_available_slots_option_button_item_selected(index: int):
	if index < 0:
		add_resource_button.disabled = true
	else:
		add_resource_button.disabled = false
		
func _on_add_button_pressed():
	slot_controller.add_hide_slot(available_slots_option_button.get_item_text(available_slots_option_button.get_selected_id()))
	slot_controller.save_resource()
	reset_inputs()
	resource_created.emit()
	
func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	available_slots_option_button = create_option_button()
	available_slots_option_button.item_selected.connect(_on_available_slots_option_button_item_selected)
	available_slots_option_button.text = "Select a Slot"
	add_resource_button = create_add_button()
	reset_inputs()
	
func parent_controls():
	var hbox: HBoxContainer = create_hbox(10)
	hbox.add_child(available_slots_option_button)
	hbox.add_child(add_resource_button)
	main_panel_container.add_child(hbox)

func _init(s_controller: AWOCResourceControllerBase):
	slot_controller = s_controller
	create_controls()
	parent_controls()
