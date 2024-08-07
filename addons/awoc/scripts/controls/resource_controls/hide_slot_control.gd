@tool
class_name AWOCHideSlotControl extends AWOCResourceControlBase

var label: Label
var hide_slot_name: String
var slot_controller: AWOCSlotController

func _on_delete_confirmed():
	slot_controller.delete_hide_slot(hide_slot_name)
	resource_deleted.emit()
	
func _on_delete_button_pressed():
	delete_confirmation_dialog = create_delete_confirmation_dialog(slot_controller.resource_name)
	delete_confirmation_dialog.visible = true
	main_panel_container.add_child(delete_confirmation_dialog)	

func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	label = create_label(hide_slot_name)
	label.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	delete_button = create_delete_button()
	delete_confirmation_dialog = create_confirmation_dialog("Delete " + hide_slot_name + "?", "Are you sure you wish to delete " + hide_slot_name + "? This can not be undone.")
	delete_confirmation_dialog.confirmed.connect(_on_delete_confirmed)
	
func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(label)
	hbox.add_child(delete_button)
	main_panel_container.add_child(hbox)
	main_panel_container.add_child(delete_confirmation_dialog)
	
func _init(s_controller: AWOCSlotController, h_slot_name: String):
	slot_controller = s_controller
	hide_slot_name = h_slot_name
	create_controls()
	parent_controls()
