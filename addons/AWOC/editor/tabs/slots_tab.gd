@tool
class_name AWOCSlotsTab
extends AWOCTabBase

var name_line_edit := AWOCLineEdit.new("Slot Name")


func _init(awoc: AWOCResource, awoc_uid: int) -> void:
	resource_manager = AWOCEditorSlotResourceManager.new()
	resource_manager.init_resource_manager(awoc, awoc_uid, awoc.slot_manager.slot_dictionary)
	create_resource_button = AWOCButton.new("Create Slot")
	super("New Slot", "Manage Slots")
		
		
func reset_controls() -> void:
	name_line_edit.text = ""
	super()
		
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(name_line_edit)
	new_resource_content_vbox.add_child(create_resource_button)
	
	
func set_control_listeners() -> void:
	super()
	name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	create_resource_button.pressed.connect(_on_create_slot_button_pressed)
	
		
func populate_manage_resources() -> void:
	clear_manage_resources_area()
	for slot_name in resource_manager.get_sorted_name_array():
		var control := AWOCControl.new(slot_name)
		control.rename.connect(_on_resource_renamed)
		control.delete.connect(_on_resource_deleted)
		manage_resources_content_vbox.add_child(control)
	
		
func _on_name_line_edit_text_changed(new_text: String) -> void:
	if AWOCGlobal.is_valid_name(name_line_edit.text):
		create_resource_button.disabled = false
	else:
		create_resource_button.disabled = true
	
	
func _on_create_slot_button_pressed() -> void:
	resource_manager.add_resource(name_line_edit.text, AWOCSlotResource.new())
	reset_controls()
	set_manage_button_disabled()
