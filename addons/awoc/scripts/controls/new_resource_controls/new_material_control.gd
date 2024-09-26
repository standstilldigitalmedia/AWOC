@tool
class_name AWOCNewMaterialControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var settings_vbox_container: VBoxContainer
var new_material_vbox_container: VBoxContainer
var albedo_checkbox: CheckBox
var orm_checkbox: CheckBox
var occlusion_checkbox: CheckBox
var roughness_checkbox: CheckBox
var metallic_checkbox: CheckBox
var apply_settings_button: Button
var name_line_edit: LineEdit
var albedo_image_control: AWOCImageControl
var orm_image_control: AWOCImageControl
var occlusion_image_control: AWOCImageControl
var roughness_image_control: AWOCImageControl
var metallic_image_control: AWOCImageControl
var create_new_resource_button: Button
#var overlay_tab: AWOCOverlaysTab
#var overlays_dictionary: Dictionary

func show_material_settings():
	settings_vbox_container.visible = true
	new_material_vbox_container.visible = false
	
func show_new_material_controls():
	new_material_vbox_container.visible = true
	settings_vbox_container.visible = false

func reset_controls():
	name_line_edit.text = ""
	albedo_image_control.reset_controls()
	orm_image_control.reset_controls()
	occlusion_image_control.reset_controls()
	roughness_image_control.reset_controls()
	metallic_image_control.reset_controls()
	create_new_resource_button.disabled = true
	#overlays_dictionary = Dictionary()
	#overlay_tab = AWOCOverlaysTab.new("",overlays_dictionary,awoc_resource_controller)
	if awoc_resource_controller.get_material_settings().has("albedo") and awoc_resource_controller.get_material_settings()["albedo"] == true:
		show_new_material_controls()
	else:
		show_material_settings()
	super()

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	if !is_image_file(albedo_image_control.path_line_edit.text):
		create_new_resource_button.disabled = true
		return
	var material_settings_dictionary: Dictionary = awoc_resource_controller.get_material_settings()
	if material_settings_dictionary["orm"] == true:
		if !is_image_file(orm_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_dictionary["occlusion"] == true:
		if !is_image_file(occlusion_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_dictionary["roughness"] == true:
		if !is_image_file(roughness_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_dictionary["metallic"] == true:
		if !is_image_file(metallic_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	create_new_resource_button.disabled = false		
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	var material_res: AWOCMaterial = AWOCMaterial.new()
	var material_settings_dictionary: Dictionary = awoc_resource_controller.get_material_settings()
	var albedo_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	awoc_resource_controller.set_image_width_and_height(albedo_image_control.path_line_edit.text)
	albedo_resource_reference.resource_uid = ResourceLoader.get_resource_uid(albedo_image_control.path_line_edit.text)
	material_res.image_dictionary["albedo"] = albedo_resource_reference
	if material_settings_dictionary["orm"] == true:
		var orm_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		orm_resource_reference.resource_uid = ResourceLoader.get_resource_uid(orm_image_control.path_line_edit.text)
		material_res.image_dictionary["orm"] = orm_resource_reference
	if material_settings_dictionary["occlusion"] == true:
		var occlusion_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		occlusion_resource_reference.resource_uid = ResourceLoader.get_resource_uid(occlusion_image_control.path_line_edit.text)
		material_res.image_dictionary["occlusion"] = occlusion_resource_reference
	if material_settings_dictionary["roughness"] == true:
		var roughness_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		roughness_resource_reference.resource_uid = ResourceLoader.get_resource_uid(roughness_image_control.path_line_edit.text)
		material_res.image_dictionary["roughness"] = roughness_resource_reference
	if material_settings_dictionary["metallic"] == true:
		var metallic_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		metallic_resource_reference.resource_uid = ResourceLoader.get_resource_uid(metallic_image_control.path_line_edit.text)
		material_res.image_dictionary["metallic"] = metallic_resource_reference
	#material_res.overlays_dictionary = overlays_dictionary
	awoc_resource_controller.add_new_material(name_line_edit.text, material_res)
	controls_reset.emit()

func _on_other_checked(toggled_on: bool):
	if toggled_on:
		orm_checkbox.set_pressed_no_signal(false)
		
func _on_orm_checked(toggled_on: bool):
	if toggled_on:
		occlusion_checkbox.set_pressed_no_signal(false)
		roughness_checkbox.set_pressed_no_signal(false)
		metallic_checkbox.set_pressed_no_signal(false)
		
func _on_apply_settings_pressed():
	awoc_resource_controller.set_material_settings(true,orm_checkbox.button_pressed, occlusion_checkbox.button_pressed, roughness_checkbox.button_pressed, metallic_checkbox.button_pressed)
	parent_new_material_controls()
	controls_reset.emit()
	
func create_new_material_controls():
	name_line_edit = create_name_line_edit("Material Name")
	albedo_image_control = AWOCImageControl.new("Albedo")
	orm_image_control = AWOCImageControl.new("ORM")
	occlusion_image_control = AWOCImageControl.new("Occlusion")
	roughness_image_control = AWOCImageControl.new("Roughness")
	metallic_image_control = AWOCImageControl.new("Metallic")
	create_new_resource_button = create_add_new_resource_button("Create Material")
	#overlay_tab = AWOCOverlaysTab.new("",overlays_dictionary,awoc_resource_controller)
	new_material_vbox_container = create_vbox(5)
	
func parent_new_material_controls():
	var material_settings_dictionary: Dictionary = awoc_resource_controller.get_material_settings()
	new_material_vbox_container.add_child(name_line_edit)
	new_material_vbox_container.add_child(albedo_image_control)
	if material_settings_dictionary["orm"] == true:
		new_material_vbox_container.add_child(orm_image_control)
	if material_settings_dictionary["occlusion"] == true:
		new_material_vbox_container.add_child(occlusion_image_control)
	if material_settings_dictionary["roughness"] == true:
		new_material_vbox_container.add_child(roughness_image_control)
	if material_settings_dictionary["metallic"] == true:
		new_material_vbox_container.add_child(metallic_image_control)
	#new_material_vbox_container.add_child(overlay_tab)
	new_material_vbox_container.add_child(create_new_resource_button)
	
func create_material_setttings_controls():
	settings_vbox_container = create_vbox(5)
	albedo_checkbox = CheckBox.new() 
	orm_checkbox = CheckBox.new() 
	occlusion_checkbox = CheckBox.new() 
	roughness_checkbox = CheckBox.new() 
	metallic_checkbox = CheckBox.new() 
	albedo_checkbox.text = "Albedo"
	albedo_checkbox.set_pressed_no_signal(true)
	albedo_checkbox.disabled = true
	orm_checkbox.set_pressed_no_signal(false)
	orm_checkbox.text = "ORM"
	occlusion_checkbox.set_pressed_no_signal(false)
	occlusion_checkbox.text = "Occlusion"
	roughness_checkbox.set_pressed_no_signal(false)
	roughness_checkbox.text = "Roughness"
	metallic_checkbox.set_pressed_no_signal(false)
	metallic_checkbox.text = "Metallic"
	apply_settings_button = Button.new()
	apply_settings_button.text = "Apply Settings"
	apply_settings_button.pressed.connect(_on_apply_settings_pressed)
	
func parent_material_setttings_controls():
	var settings_grid_container = create_grid_container()
	settings_grid_container.columns = 2
	settings_grid_container.add_child(albedo_checkbox)
	settings_grid_container.add_child(orm_checkbox)
	settings_grid_container.add_child(occlusion_checkbox)
	settings_grid_container.add_child(roughness_checkbox)
	settings_grid_container.add_child(metallic_checkbox)
	settings_vbox_container.add_child(create_label("AWOC Material Properties"))
	settings_vbox_container.add_child(settings_grid_container)
	settings_vbox_container.add_child(apply_settings_button)
	
func set_material_setttings_listeners():
	orm_checkbox.toggled.connect(_on_orm_checked)
	occlusion_checkbox.toggled.connect(_on_other_checked)
	roughness_checkbox.toggled.connect(_on_other_checked)
	metallic_checkbox.toggled.connect(_on_other_checked)
	
func set_new_material_listeners():
	albedo_image_control.validate.connect(validate_inputs)
	orm_image_control.validate.connect(validate_inputs)
	occlusion_image_control.validate.connect(validate_inputs)
	roughness_image_control.validate.connect(validate_inputs)
	metallic_image_control.validate.connect(validate_inputs)
	
func parent_controls():
	parent_material_setttings_controls()
	if awoc_resource_controller.get_material_settings().has("albedo") and awoc_resource_controller.get_material_settings()["albedo"] == true:
		parent_new_material_controls()
	control_panel_container_vbox.add_child(settings_vbox_container)
	control_panel_container_vbox.add_child(new_material_vbox_container)
	super()
		
func create_controls():
	tab_button = create_new_resource_toggle_button("New Material")
	create_new_material_controls()
	create_material_setttings_controls()
	super()
		
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
	set_material_setttings_listeners()
	set_new_material_listeners()
	reset_controls()
