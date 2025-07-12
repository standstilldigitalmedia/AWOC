@tool
class_name AWOCSlotsTab
extends AWOCTabBase

var slot_manager: AWOCEditorSlotResourceManager
var name_line_edit := AWOCLineEdit.new("Slot Name")
var create_slot_button := AWOCButton.new("Create Slot")

func _init(awoc: AWOCResource, awoc_uid: int) -> void:
	slot_manager = AWOCEditorSlotResourceManager.new()
	slot_manager.init_resource_manager(awoc, awoc_uid, awoc.slot_manager.slot_dictionary)
	super("New Slot", "Manage Slots")


func set_manage_button_disabled() -> void:
	if slot_manager.has_resources():
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		
		
func reset_controls() -> void:
	name_line_edit.text = ""
	create_slot_button.disabled = true
	populate_manage_slots_area()
	
func reset_tab() -> void:
	super()
	reset_controls()
	set_manage_button_disabled()
		
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(name_line_edit)
	new_resource_content_vbox.add_child(create_slot_button)
	
	
func set_control_listeners() -> void:
	super()
	name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	create_slot_button.pressed.connect(_on_create_slot_button_pressed)
	
		
func populate_manage_slots_area() -> void:
	clear_manage_resources_area()
	for slot_name in slot_manager.get_sorted_name_array():
		var control := AWOCControl.new(slot_name)
		control.rename.connect(_on_slot_renamed)
		control.delete.connect(_on_slot_deleted)
		manage_resources_content_vbox.add_child(control)
	
		
func _on_name_line_edit_text_changed(new_text: String) -> void:
	if AWOCGlobal.is_valid_name(name_line_edit.text):
		create_slot_button.disabled = false
	else:
		create_slot_button.disabled = true
	
	
func _on_create_slot_button_pressed() -> void:
	slot_manager.add_slot(name_line_edit.text)
	reset_controls()
	set_manage_button_disabled()
	
func _on_slot_renamed(old_name: String, new_name: String) -> void:
	slot_manager.rename_slot(old_name, new_name)
	reset_controls()
	
	
func _on_slot_deleted(slot_name) -> void:
	slot_manager.delete_slot(slot_name)
	if slot_manager.get_dictionary().size() > 0:
		reset_controls()
	else:
		reset_tab()
	
