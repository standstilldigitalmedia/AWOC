@tool
class_name AWOCNewOverlayControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var material_name: String
var overlay_type_option_button: OptionButton
var name_line_edit: LineEdit
var create_new_resource_button: Button
var image_control: AWOCImageControl
var dynamic_color_image_control: AWOCDynamicColorImageControl
var shared_color_image_control: AWOCSharedColorImageControl
	
func set_overlay_type_option_button():
	overlay_type_option_button.clear()
	overlay_type_option_button.add_item("Image")
	overlay_type_option_button.add_item("Color")
	if awoc_resource_controller.get_colors_dictionary().size() > 0:
		overlay_type_option_button.add_item("Shared Color")
	overlay_type_option_button.selected = -1
	overlay_type_option_button.set_pressed_no_signal(false)

func reset_controls():
	name_line_edit.text = ""
	create_new_resource_button.disabled = true
	set_overlay_type_option_button()
	image_control.reset_controls()
	dynamic_color_image_control.reset_controls()
	shared_color_image_control.reset_controls()
	image_control.visible = false
	dynamic_color_image_control.visible = false
	shared_color_image_control.visible = false
	super()
	
func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	match overlay_type_option_button.selected:
		0:
			if !is_image_file(image_control.path_line_edit.text):
				create_new_resource_button.disabled = true
				return
		1:
			if !is_image_file(dynamic_color_image_control.path_line_edit.text):
				create_new_resource_button.disabled = true
				return
		2:
			if !is_image_file(shared_color_image_control.path_line_edit.text) or shared_color_image_control.shared_color_option_button.selected < 0:
				create_new_resource_button.disabled = true
				return		
	create_new_resource_button.disabled = false

func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_path_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	var overlay_resource: AWOCOverlay = AWOCOverlay.new()
	var image_reference: AWOCResourceReference = AWOCResourceReference.new()
	var path: String = ResourceUID.get_id_path(awoc_resource_controller.awoc_uid).get_base_dir() + "/overlays"
	match overlay_type_option_button.selected:
		0:
			image_reference.resource_uid = ResourceLoader.get_resource_uid(image_control.path_line_edit.text)
			overlay_resource.dynamic_color = Color(0,0,0,0)
			overlay_resource.shared_color = ""
		1:
			image_reference.resource_uid = ResourceLoader.get_resource_uid(dynamic_color_image_control.path_line_edit.text)
			overlay_resource.dynamic_color = dynamic_color_image_control.color_picker_button.color
			overlay_resource.shared_color = ""
		2:
			image_reference.resource_uid = ResourceLoader.get_resource_uid(shared_color_image_control.path_line_edit.text)
			overlay_resource.dynamic_color = Color(0,0,0,0)
			overlay_resource.shared_color = shared_color_image_control.shared_color_option_button.get_item_text(shared_color_image_control.shared_color_option_button.selected)	
	overlay_resource.overlay_image_reference = image_reference
	awoc_resource_controller.add_new_overlay(name_line_edit.text, material_name, overlay_resource)
	controls_reset.emit()
	
func _on_overlay_type_changed(index: int):
	overlay_type_option_button.selected = index
	if index < 0:
		return
	match index:
		0:
			image_control.visible = true
			dynamic_color_image_control.visible = false
			shared_color_image_control.visible = false
		1:
			image_control.visible = false
			dynamic_color_image_control.visible = true
			shared_color_image_control.visible = false
		2:
			image_control.visible = false
			dynamic_color_image_control.visible = false
			shared_color_image_control.visible = true
			
func create_controls():
	tab_button = create_new_resource_toggle_button("New Overlay")
	overlay_type_option_button = OptionButton.new()
	overlay_type_option_button.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	overlay_type_option_button.item_selected.connect(_on_overlay_type_changed)
	set_overlay_type_option_button()
	name_line_edit = create_name_line_edit("Overlay Name")
	create_new_resource_button = create_add_new_resource_button("Create Overlay")
	image_control = AWOCImageControl.new("Image Overlay")
	dynamic_color_image_control = AWOCDynamicColorImageControl.new("Dynamic Color")
	shared_color_image_control = AWOCSharedColorImageControl.new("Shared Color", awoc_resource_controller.get_colors_dictionary())
	image_control.visible = false
	dynamic_color_image_control.visible = false
	shared_color_image_control.visible = false
	super()
	
func parent_controls():
	super()
	var hbox: HBoxContainer = create_hbox(5)
	hbox.add_child(create_label("Overlay Type:"))
	hbox.add_child(overlay_type_option_button)
	control_panel_container_vbox.add_child(hbox)
	control_panel_container_vbox.add_child(image_control)
	control_panel_container_vbox.add_child(dynamic_color_image_control)
	control_panel_container_vbox.add_child(shared_color_image_control)
	control_panel_container_vbox.add_child(name_line_edit)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(ar_controller: AWOCResourceController, mat_name: String):
	awoc_resource_controller = ar_controller
	material_name = mat_name
	super()
	reset_controls()
