@tool
class_name AWOCNewMeshControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var multi_mesh_line_edit: LineEdit
var single_mesh_line_edit: LineEdit
var create_new_resource_button: Button

func reset_controls():
	multi_mesh_line_edit.text = ""
	single_mesh_line_edit.text = ""
	create_new_resource_button.disabled = true

func validate_inputs():
	if is_avatar_file(multi_mesh_line_edit.text):
		create_new_resource_button.disabled = false
		return
	if single_mesh_line_edit.text.is_absolute_path():
		create_new_resource_button.disabled = false
		return
	create_new_resource_button.disabled = true
	
func _on_multi_mesh_line_edit_text_changed(new_text: String):
	single_mesh_line_edit.text = ""
	validate_inputs()

func _on_single_mesh_line_edit_text_changed(new_text: String):
	multi_mesh_line_edit.text = ""
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	awoc_resource_controller.create_avatar(multi_mesh_line_edit.text)
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Mesh(es)")
	multi_mesh_line_edit = create_multi_mesh_line_edit()
	single_mesh_line_edit = create_single_mesh_line_edit()
	create_new_resource_button = create_add_new_resource_button("Add Mesh(es)")
	super()
	
func parent_controls():
	super()
	control_panel_container_vbox.add_child(multi_mesh_line_edit)
	control_panel_container_vbox.add_child(single_mesh_line_edit)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
