@tool
class_name AWOCNewSlotControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var name_line_edit: LineEdit
var create_new_resource_button: Button
var hide_slots_tab: AWOCHideSlotsTab
var hide_slots_array: Array[String]

func reset_controls():
	name_line_edit.text = ""
	create_new_resource_button.disabled = true
	hide_slots_array.clear()
	hide_slots_tab.reset_controls()

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	create_new_resource_button.disabled = false
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	awoc_resource_controller.add_new_slot(name_line_edit.text, hide_slots_array)
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Slot")
	name_line_edit = create_name_line_edit("Slot Name")
	create_new_resource_button = create_add_new_resource_button("Create Slot")
	hide_slots_tab = AWOCHideSlotsTab.new(awoc_resource_controller, hide_slots_array, "")
	super()
	
func parent_controls():
	super()
	control_panel_container_vbox.add_child(name_line_edit)
	control_panel_container_vbox.add_child(hide_slots_tab)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
