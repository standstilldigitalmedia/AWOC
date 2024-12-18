@tool
class_name AWOCSlotControl extends AWOCResourceControlBase

var awoc_resource_controller: AWOCResourceController
var slot_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var hide_button: Button
var show_button: Button
var rename_confimation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog
var hide_slots_tab: AWOCHideSlotsTab
var hide_slot_panel_container: PanelContainer

func _on_delete_confirmed():
	awoc_resource_controller.remove_slot(slot_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_slot(slot_name, name_line_edit.text)
	controls_reset.emit()
	
func _on_rename_button_pressed():
	rename_confimation_dialog.visible = true
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func _on_name_line_edit_text_changed(new_text: String):
	if is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true
		
func _on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	hide_slot_panel_container.visible = true
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	hide_slot_panel_container.visible = false

func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit("Slot Name", slot_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false
	rename_confimation_dialog = create_rename_confirmation_dialog(slot_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(slot_name)
	hide_slots_tab = AWOCHideSlotsTab.new(awoc_resource_controller, awoc_resource_controller.get_slot_by_name(slot_name).hide_slots_array, slot_name)
	hide_slot_panel_container = create_simi_transparent_panel_container()
	hide_slot_panel_container.visible = false
	super()
	
func parent_controls():
	var hide_slot_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	var vbox = create_vbox(0)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	hide_slot_panel_container.add_child(hide_slot_panel_margin_container)
	hide_slot_panel_margin_container.add_child(hide_slots_tab)
	vbox.add_child(hbox)
	vbox.add_child(hide_slot_panel_container)
	add_child(vbox)
	super()

func _init(a_controller: AWOCResourceController, s_name: String):
	awoc_resource_controller = a_controller
	slot_name = s_name
	super()
