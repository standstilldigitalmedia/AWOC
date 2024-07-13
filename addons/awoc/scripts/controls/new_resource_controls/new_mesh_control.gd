@tool
class_name AWOCNewMeshControl extends AWOCNewResourceControlBase

"""func reset_inputs():
	name_line_edit.text = ""
	create_resource_button.disabled = true

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
	
func on_create_resource_button_pressed():
	if validate_inputs():
		var new_slot = AWOCSlot.new()
		#new_slot.name = name_line_edit.text
		var new_slot_resource_controller: AWOCDictionaryResourceController = AWOCDictionaryResourceController.new(new_slot,resource_controller.resource_controller,resource_controller.dictionary)
		new_slot_resource_controller.create_resource()
		#hide_slot_tab.reset_tab()
		resource_created.emit()
		
func create_controls():
	main_panel_container = PanelContainer.new()
	main_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	name_line_edit = create_line_edit("Slot Name")
	create_resource_button = Button.new()
	create_resource_button.text = "Create Slot"
	name_line_edit.text_changed.connect(on_name_line_edit_text_changed)
	create_resource_button.disabled = true
	var new_slot: AWOCSlot = AWOCSlot.new()
	var hide_slot_tab_resource_controller: AWOCDictionaryResourceController = AWOCDictionaryResourceController.new(new_slot, resource_controller.resource_controller, new_slot.hide_slot_dictionary)
	hide_slot_tab = AWOCHideSlotTab.new(hide_slot_tab_resource_controller)
	hide_slot_tab.set_tab_button_text("New Hide Slot", "Manage Hide Slots")
	
func parent_controls():
	var vbox: VBoxContainer = create_vbox(10)
	vbox.add_child(name_line_edit)
	vbox.add_child(hide_slot_tab.main_panel_container)
	vbox.add_child(create_resource_button)
	main_panel_container.add_child(vbox)
	
func _init(r_resource_controller: AWOCDictionaryResourceController):
	super(r_resource_controller)"""
