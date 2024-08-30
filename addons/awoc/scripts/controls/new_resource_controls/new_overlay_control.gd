@tool
class_name AWOCNewOverlayControl extends AWOCNewResourceControlBase

var overlays_dictionary: Dictionary
var name_line_edit: LineEdit
var create_new_resource_button: Button

func reset_controls():
	name_line_edit.text = ""
	create_new_resource_button.disabled = true

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	create_new_resource_button.disabled = false
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	#awoc_resource_controller.add_new_slot(name_line_edit.text, hide_slots_array)
	control_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Overlay")
	name_line_edit = create_name_line_edit("Overlay Name")
	create_new_resource_button = create_add_new_resource_button("Create Overlay")
	super()
	
func parent_controls():
	super()
	control_panel_container_vbox.add_child(name_line_edit)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(dict: Dictionary):
	overlays_dictionary = dict
	super()
