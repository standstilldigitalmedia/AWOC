@tool
class_name AWOCHideSlotControl extends AWOCResourceControlBase

var hide_slot_name: String
var hide_slot_array: Array[String]
var name_line_edit: LineEdit
var delete_button: Button
var delete_confirmation_dialog: ConfirmationDialog

func _on_delete_confirmed():
	for a in hide_slot_array.size():
		if hide_slot_array[a] == hide_slot_name:
			hide_slot_array.remove_at(a)
			break
	controls_reset.emit()
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true

func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit(hide_slot_name)
	name_line_edit.editable = false
	delete_button = create_delete_button()
	delete_confirmation_dialog = create_delete_confirmation_dialog(hide_slot_name)
	super()
	
func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(delete_button)
	hbox.add_child(delete_confirmation_dialog)
	add_child(hbox)
	super()

func _init(hs_name: String, hs_array: Array[String]):
	hide_slot_name = hs_name
	hide_slot_array = hs_array
	super()
