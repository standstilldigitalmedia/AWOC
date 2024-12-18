@tool
class_name AWOCOverlayControl extends AWOCResourceControlBase

var awoc_resource_controller: AWOCResourceController
var overlay_name: String
var material_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var show_button: Button
var hide_button: Button
var overlay_panel_container: PanelContainer
var rename_confirmation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog
var image_control: AWOCImageControl
var dynamic_color_image_control: AWOCDynamicColorImageControl
var shared_color_image_control: AWOCSharedColorImageControl
var overlay_type_option_button: OptionButton
var overlay_strength_slider: HSlider
var overlay_strength_line_edit: LineEdit
var old_overlay_strength: String = "1"

func validate_inputs():
	image_control.validate_inputs()
	dynamic_color_image_control.validate_inputs()
	shared_color_image_control.validate_inputs()
	
func set_shared_color_option_button(overlay: AWOCOverlay):
	for a in shared_color_image_control.shared_color_option_button.item_count:
		if shared_color_image_control.shared_color_option_button.get_item_text(a) == overlay.shared_color:
			shared_color_image_control.shared_color_option_button.selected = a
			break

func set_overlay_type_option_button():
	overlay_type_option_button = OptionButton.new()
	overlay_type_option_button.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	overlay_type_option_button.clear()
	overlay_type_option_button.add_item("Image")
	overlay_type_option_button.add_item("Color")
	if awoc_resource_controller.get_colors_dictionary().size() > 0:
		overlay_type_option_button.add_item("Shared Color")
	overlay_type_option_button.item_selected.connect(_on_overlay_type_changed)
	
func _on_overlay_type_changed(index: int):
	if index < 0:
		return
	match index:
		0:
			image_control.visible = true
			dynamic_color_image_control.visible = false
			shared_color_image_control.visible = false
			awoc_resource_controller.update_overlay(material_name, overlay_name, image_control.path_line_edit.text, Color(0,0,0,0), "")
		1:
			dynamic_color_image_control.color_picker_button.color = Color(0,0,0,1)
			image_control.visible = false
			dynamic_color_image_control.visible = true
			shared_color_image_control.visible = false
			awoc_resource_controller.update_overlay(material_name, overlay_name, image_control.path_line_edit.text, Color(0,0,0,0), "")
		2:
			var awoc_overlay: AWOCOverlay = material.overlays_dictionary[overlay_name]
			set_shared_color_option_button(awoc_overlay)
			shared_color_image_control.shared_color_option_button.selected = -1
			image_control.visible = false
			dynamic_color_image_control.visible = false
			shared_color_image_control.visible = true
			awoc_resource_controller.update_overlay(material_name, overlay_name, image_control.path_line_edit.text, Color(0,0,0,0), "")
	validate_inputs()

func _on_delete_confirmed():
	awoc_resource_controller.remove_overlay(material_name,overlay_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_overlay(material_name,overlay_name,name_line_edit.text)
	controls_reset.emit()
	
func _on_rename_button_pressed():
	rename_confirmation_dialog.visible = true
	
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
	overlay_panel_container.visible = true
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	overlay_panel_container.visible = false
	
func _on_image_control_validate():
	awoc_resource_controller.update_overlay(material_name, overlay_name, image_control.path_line_edit.text, Color(0,0,0,0),"")
	
func _on_dynamic_color_image_control_validate():
	awoc_resource_controller.update_overlay(material_name, overlay_name, dynamic_color_image_control.path_line_edit.text, dynamic_color_image_control.color_picker_button.color,"")
	
func _on_shared_color_image_control_validate():
	if shared_color_image_control.shared_color_option_button.selected >= 0:
		awoc_resource_controller.update_overlay(material_name, overlay_name, shared_color_image_control.path_line_edit.text, Color(0,0,0,0),shared_color_image_control.shared_color_option_button.get_item_text(shared_color_image_control.shared_color_option_button.selected))
		
func _on_overlay_strength_slider_changed(value: float):
	overlay_strength_line_edit.text = str(value)
	old_overlay_strength = str(value)
	
func _on_overlay_strength_line_edit_text_change(new_text: String):
	if new_text == "":
		pass
	elif !new_text.is_valid_float():
		overlay_strength_line_edit.text = old_overlay_strength
	elif float(overlay_strength_line_edit.text) > 1:
		overlay_strength_line_edit.text = "1"
		old_overlay_strength = "1"
	elif float(overlay_strength_line_edit.text) < 0:
		overlay_strength_line_edit.text = "0"
		old_overlay_strength = "0"
	else:
		old_overlay_strength = new_text
	overlay_strength_line_edit.caret_column = overlay_strength_line_edit.text.length()
	overlay_strength_slider.set_value_no_signal(float(overlay_strength_line_edit.text))
	awoc_resource_controller.update_overlay_strength(material_name, overlay_name, overlay_strength_slider.value)
	
func _on_overlay_strength_slider_end(value_changed: bool):
	if value_changed:
		awoc_resource_controller.update_overlay_strength(material_name, overlay_name, overlay_strength_slider.value)
	
func create_controls():
	name_line_edit = create_name_line_edit("Overlay Name", overlay_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false
	overlay_panel_container = create_simi_transparent_panel_container()
	overlay_panel_container.visible = false
	rename_confirmation_dialog = create_rename_confirmation_dialog(overlay_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(overlay_name)
	image_control = AWOCImageControl.new("Image Overlay")
	dynamic_color_image_control = AWOCDynamicColorImageControl.new("Dynamic Color")
	shared_color_image_control = AWOCSharedColorImageControl.new("Shared Color", awoc_resource_controller.get_colors_dictionary())
	image_control.validate.connect(_on_image_control_validate)
	dynamic_color_image_control.validate.connect(_on_dynamic_color_image_control_validate)
	shared_color_image_control.validate.connect(_on_shared_color_image_control_validate)
	set_overlay_type_option_button()
	var awoc_material = awoc_resource_controller.get_material_by_name(material_name)
	var awoc_overlay: AWOCOverlay = awoc_material.overlays_dictionary[overlay_name]
	var image_path: String = ResourceUID.get_id_path(awoc_overlay.overlay_image_reference.resource_uid)
	var image = load(image_path)
	if awoc_overlay.shared_color != "":
		overlay_type_option_button.selected = 2
		set_shared_color_option_button(awoc_overlay)
		image_control.visible = false
		dynamic_color_image_control.visible = false
		shared_color_image_control.visible = true
	elif awoc_overlay.dynamic_color != Color(0,0,0,0):
		overlay_type_option_button.selected = 1
		dynamic_color_image_control.color_picker_button.color = awoc_overlay.dynamic_color
		image_control.visible = false
		dynamic_color_image_control.visible = true
		shared_color_image_control.visible = false
	else:
		image_control.visible = true
		dynamic_color_image_control.visible = false
		shared_color_image_control.visible = false
	image_control.texture_rect.texture = image
	dynamic_color_image_control.texture_rect.texture = image
	shared_color_image_control.texture_rect.texture = image
	image_control.path_line_edit.text = image_path
	dynamic_color_image_control.path_line_edit.text = image_path
	shared_color_image_control.path_line_edit.text = image_path
	overlay_strength_slider = HSlider.new()
	overlay_strength_slider.min_value = 0.0
	overlay_strength_slider.max_value = 1.0
	overlay_strength_slider.set_value_no_signal(1.0)
	overlay_strength_slider.value_changed.connect(_on_overlay_strength_slider_changed)
	overlay_strength_slider.drag_ended.connect(_on_overlay_strength_slider_end)
	overlay_strength_slider.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	overlay_strength_slider.step = 0.001
	overlay_strength_line_edit = LineEdit.new()
	overlay_strength_line_edit.placeholder_text = "Strength"
	overlay_strength_line_edit.text = "1"
	overlay_strength_line_edit.text_changed.connect(_on_overlay_strength_line_edit_text_change)
	
func parent_controls():
	var outer_vbox: VBoxContainer = create_vbox(0)
	var hbox: HBoxContainer = create_hbox(5)
	var panel: PanelContainer = create_simi_transparent_panel_container()
	var overlay_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	var inner_vbox: VBoxContainer = create_vbox(0)
	var inner_hbox: HBoxContainer = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	inner_hbox.add_child(create_label("Overlay Type:"))
	inner_hbox.add_child(overlay_type_option_button)
	inner_vbox.add_child(inner_hbox)
	inner_vbox.add_child(image_control)
	inner_vbox.add_child(dynamic_color_image_control)
	inner_vbox.add_child(shared_color_image_control)
	var strength_hbox: HBoxContainer = create_hbox(5)
	strength_hbox.add_child(create_label("Overlay strength:"))
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(overlay_strength_slider)
	strength_hbox.add_child(vbox)
	strength_hbox.add_child(overlay_strength_line_edit)
	inner_vbox.add_child(strength_hbox)
	outer_vbox.add_child(hbox)
	overlay_panel_margin_container.add_child(inner_vbox)
	overlay_panel_container.add_child(overlay_panel_margin_container)
	outer_vbox.add_child(overlay_panel_container)
	outer_vbox.add_child(rename_confirmation_dialog)
	outer_vbox.add_child(delete_confirmation_dialog)
	add_child(outer_vbox)
	
func set_overlay_controls():
	var awoc_overlay: AWOCOverlay = awoc_resource_controller.get_overlay_by_name(material_name, overlay_name)
	if awoc_overlay.dynamic_color != Color(0,0,0,0):
		dynamic_color_image_control.color_picker_button.color = awoc_overlay.dynamic_color
		dynamic_color_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_overlay.overlay_image_reference.resource_uid))
		overlay_type_option_button.selected = 1
	elif awoc_overlay.shared_color != "":
		shared_color_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_overlay.overlay_image_reference.resource_uid))
		set_shared_color_option_button(awoc_overlay)
		overlay_type_option_button.selected = 2
	else:
		image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_overlay.overlay_image_reference.resource_uid))
		overlay_type_option_button.selected = 0
	
func _init(a_controller: AWOCResourceController, m_name: String, o_name: String):
	awoc_resource_controller = a_controller
	material_name = m_name
	overlay_name = o_name
	super()
	set_overlay_controls()
