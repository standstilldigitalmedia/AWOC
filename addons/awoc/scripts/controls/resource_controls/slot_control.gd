@tool
class_name AWOCSlotControl extends AWOCResourceControlBase

var show_button: Button
var hide_button: Button
var hide_slots_panel_container: PanelContainer
var hide_slot_tab: AWOCHideSlotTab
var slot_controller: AWOCResourceControllerBase

func _on_delete_confirmed():
	slot_controller.delete_resource_from_dictionary()
	resource_deleted.emit()
	
func _on_rename_confirmed():
	slot_controller.rename_resource_in_dictionary(name_line_edit.text)
	resource_renamed.emit()
	
func _on_rename_button_pressed():
	rename_confirmation_dialog = create_rename_confirmation_dialog(slot_controller.resource_name)
	rename_confirmation_dialog.visible = true
	main_panel_container.add_child(rename_confirmation_dialog)
	
func _on_delete_button_pressed():
	delete_confirmation_dialog = create_delete_confirmation_dialog(slot_controller.resource_name)
	delete_confirmation_dialog.visible = true
	main_panel_container.add_child(delete_confirmation_dialog)	

func _on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	hide_slots_panel_container.visible = true
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	hide_slots_panel_container.visible = false

func create_controls():
	name_line_edit = create_line_edit("Slot Name",slot_controller.resource_name)
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false
	hide_slots_panel_container = create_panel_container(1.0,1.0,1.0,0.05)
	hide_slots_panel_container.visible = false
	#hide_slot_tab = AWOCHideSlotTab.new(slot_controller)
	#hide_slot_tab.set_tab_button_text("New Hide Slot", "Manage Hide Slots")
	super()

func parent_controls():
	var vbox = create_vbox(0)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	#hide_slots_panel_container.add_child(hide_slot_tab.main_panel_container)
	vbox.add_child(hbox)
	vbox.add_child(hide_slots_panel_container)
	main_panel_container.add_child(vbox)

func _init(s_controller: AWOCResourceControllerBase):
	slot_controller = s_controller
	create_controls()
	parent_controls()
