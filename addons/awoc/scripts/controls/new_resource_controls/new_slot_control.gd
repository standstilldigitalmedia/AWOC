@tool
class_name AWOCNewSlotControl extends AWOCNewResourceControlBase

var vbox: VBoxContainer
var name_line_edit: LineEdit
var create_resource_button: Button
var hide_slot_tab: AWOCHideSlotTab
var new_slot_hide_slot_array: PackedStringArray
var awoc_resource_controller: AWOCResourceController

func reset_hide_slots_tab():
	if hide_slot_tab != null:
		hide_slot_tab.queue_free()
	hide_slot_tab = AWOCHideSlotTab.new(AWOCSlotController.new("", awoc_resource_controller.resource))
	hide_slot_tab.set_tab_button_text("New Hide Slot", "Manage Hide Slots")
	hide_slot_tab.reset_tab()

func reset_inputs():
	name_line_edit.text = ""
	create_resource_button.disabled = true
	hide_slot_tab.slot_controller.hide_slot_array = Array()
	hide_slot_tab.reset_tab()

func validate_inputs() -> bool:
	if !is_valid_name(name_line_edit.text):
		create_resource_button.disabled = true
		return false
	create_resource_button.disabled = false
	return true
	
func on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func on_path_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	if validate_inputs():
		var new_slot_controller: AWOCSlotController = AWOCSlotController.new(name_line_edit.text,awoc_resource_controller.resource)
		new_slot_controller.create_resource()
		resource_created.emit()
		hide_slot_tab.reset_tab()
		
		"""slot_resource_controller.resource = AWOCSlot.new()
		slot_resource_controller.dictionary[name_line_edit.text] = new_slot_hide_slot_array
		slot_resource_controller.save_resource()
		new_slot_hide_slot_array = Array()
		#hide_slot_tab.reset_tab()
		resource_created.emit()"""
		
func create_controls():
	main_panel_container = PanelContainer.new()
	main_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	name_line_edit = create_line_edit("Slot Name")
	create_resource_button = create_add_new_resource_button("Add Slot")
	name_line_edit.text_changed.connect(on_name_line_edit_text_changed)
	create_resource_button.disabled = true
	reset_hide_slots_tab()
	
func parent_controls():
	if vbox != null:
		vbox.queue_free()
		create_controls()
	vbox = create_vbox(10)
	vbox.add_child(name_line_edit)
	vbox.add_child(hide_slot_tab.main_panel_container)
	vbox.add_child(create_resource_button)
	main_panel_container.add_child(vbox)

func _init(a_controller: AWOCResourceController):
	awoc_resource_controller = a_controller
	create_controls()
	parent_controls()
