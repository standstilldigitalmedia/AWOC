@tool
class_name AWOCEditorProperty extends EditorProperty

var updating = false
var tab_bar: TabBar
var awoc_resource_controller: AWOCDiskResourceController

func _init(r_awoc_resource_controller: AWOCDiskResourceController):
	awoc_resource_controller = r_awoc_resource_controller
	var tab_control = AWOCTabBarTab.new(awoc_resource_controller)
	var vbox = VBoxContainer.new()
	vbox.add_child(tab_control.main_panel_container)
	for child in get_children():
		child.queue_free()
	add_child(vbox)
	set_bottom_editor(vbox)
	
	
	
	
	
	
	
	
	"""var slot_tab: AWOCSlotsTab = AWOCSlotsTab.new()
	var slot_tab_margin_container: MarginContainer = slot_tab.create_controls(dict, "New Slot", "Manage Slots")
	var slot = AWOCNewSlotControl.new()
	var control = slot.init_control()
	add_child(slot_tab_margin_container)
	set_bottom_editor(slot_tab_margin_container)
	#add_focusable(slot.main_vbox_container)"""

func _on_add_resource_button_pressed():
	if (updating):
		return

	"""current_value = randi() % 100
	refresh_control_text()
	emit_changed(get_edited_property(), current_value)"""


func _update_property():
	label = ""
	"""var new_value = get_edited_object()[get_edited_property()]
		
	updating = true
	current_value = new_value
	refresh_control_text()
	updating = false"""
