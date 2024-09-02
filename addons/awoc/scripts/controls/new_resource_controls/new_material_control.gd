@tool
class_name AWOCNewMaterialControl extends AWOCNewResourceControlBase

const ALBEDO = 0
const ORM = 1
const OCCLUSION = 2
const ROUGHNESS = 3
const METALLIC = 4

var awoc_resource_controller: AWOCResourceController
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
var overlay_tab: AWOCOverlaysTab
var overlays_dictionary: Dictionary

func reset_controls():
	name_line_edit.text = ""
	albedo_image_control.reset_controls()
	orm_image_control.reset_controls()
	occlusion_image_control.reset_controls()
	roughness_image_control.reset_controls()
	metallic_image_control.reset_controls()
	create_new_resource_button.disabled = true
	overlay_tab.reset_tab()
	overlays_dictionary = {}

func validate_inputs():
	if !is_valid_name(name_line_edit.text):
		create_new_resource_button.disabled = true
		return
	if !is_image_file(albedo_image_control.path_line_edit.text):
		create_new_resource_button.disabled = true
		return
	var material_settings_array: Array = awoc_resource_controller.get_material_settings()
	if material_settings_array[ORM]:
		if !is_image_file(orm_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_array[OCCLUSION]:
		if !is_image_file(occlusion_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_array[ROUGHNESS]:
		if !is_image_file(roughness_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	if material_settings_array[METALLIC]:
		if !is_image_file(metallic_image_control.path_line_edit.text):
			create_new_resource_button.disabled = true
			return
	create_new_resource_button.disabled = false		
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	var material_res: AWOCMaterial = AWOCMaterial.new()
	var material_settings_array: Array = awoc_resource_controller.get_material_settings()
	var albedo_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	albedo_resource_reference.resource_uid = ResourceLoader.get_resource_uid(albedo_image_control.path_line_edit.text)
	material_res.image_dictionary["albedo"] = albedo_resource_reference
	if material_settings_array[ORM]:
		var orm_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		orm_resource_reference.resource_uid = ResourceLoader.get_resource_uid(orm_image_control.path_line_edit.text)
		material_res.image_dictionary["orm"] = orm_resource_reference
	if material_settings_array[OCCLUSION]:
		var occlusion_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		occlusion_resource_reference.resource_uid = ResourceLoader.get_resource_uid(occlusion_image_control.path_line_edit.text)
		material_res.image_dictionary["occlusion"] = occlusion_resource_reference
	if material_settings_array[ROUGHNESS]:
		var roughness_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		roughness_resource_reference.resource_uid = ResourceLoader.get_resource_uid(roughness_image_control.path_line_edit.text)
		material_res.image_dictionary["roughness"] = roughness_resource_reference
	if material_settings_array[METALLIC]:
		var metallic_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
		metallic_resource_reference.resource_uid = ResourceLoader.get_resource_uid(metallic_image_control.path_line_edit.text)
		material_res.image_dictionary["metallic"] = metallic_resource_reference
	material_res.overlays_dictionary = overlays_dictionary
	awoc_resource_controller.add_new_material(name_line_edit.text, material_res)
	reset_controls()

func _on_other_checked(toggled_on: bool):
	if toggled_on:
		orm_checkbox.set_pressed_no_signal(false)
		
func _on_orm_checked(toggled_on: bool):
	if toggled_on:
		occlusion_checkbox.set_pressed_no_signal(false)
		roughness_checkbox.set_pressed_no_signal(false)
		metallic_checkbox.set_pressed_no_signal(false)
		
func _on_apply_settings_pressed():
	awoc_resource_controller.set_material_settings(orm_checkbox.button_pressed, occlusion_checkbox.button_pressed, roughness_checkbox.button_pressed, metallic_checkbox.button_pressed)
	show_new_material_controls()
	
func create_new_material_controls():
	name_line_edit = create_name_line_edit("Material Name")
	albedo_image_control = AWOCImageControl.new("Albedo")
	orm_image_control = AWOCImageControl.new("ORM")
	occlusion_image_control = AWOCImageControl.new("Occlusion")
	roughness_image_control = AWOCImageControl.new("Roughness")
	metallic_image_control = AWOCImageControl.new("Metallic")
	create_new_resource_button = create_add_new_resource_button("Create Material")
	overlay_tab = AWOCOverlaysTab.new("",overlays_dictionary,awoc_resource_controller)
	
func parent_new_material_controls():
	for child in control_panel_container_vbox.get_children():
		child.queue_free()
	var material_settings_array: Array = awoc_resource_controller.get_material_settings()
	control_panel_container_vbox.add_child(name_line_edit)
	control_panel_container_vbox.add_child(albedo_image_control)
	if material_settings_array[ORM]:
		control_panel_container_vbox.add_child(orm_image_control)
	if material_settings_array[OCCLUSION]:
		control_panel_container_vbox.add_child(occlusion_image_control)
	if material_settings_array[ROUGHNESS]:
		control_panel_container_vbox.add_child(roughness_image_control)
	if material_settings_array[METALLIC]:
		control_panel_container_vbox.add_child(metallic_image_control)
	control_panel_container_vbox.add_child(overlay_tab)
	control_panel_container_vbox.add_child(create_new_resource_button)
	
func create_material_setttings_controls():
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
	for child in control_panel_container_vbox.get_children():
		child.queue_free()
	var grid_container = create_grid_container()
	grid_container.columns = 2
	grid_container.add_child(albedo_checkbox)
	grid_container.add_child(orm_checkbox)
	grid_container.add_child(occlusion_checkbox)
	grid_container.add_child(roughness_checkbox)
	grid_container.add_child(metallic_checkbox)
	control_panel_container_vbox.add_child(create_label("AWOC Material Properties"))
	control_panel_container_vbox.add_child(grid_container)
	control_panel_container_vbox.add_child(apply_settings_button)
	
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
	
func show_new_material_controls():
	parent_new_material_controls()
	set_new_material_listeners()

func show_material_settings():
	parent_material_setttings_controls()
	set_material_setttings_listeners()
		
func create_controls():
	tab_button = create_new_resource_toggle_button("New Material")
	super()
		
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	create_material_setttings_controls()
	create_new_material_controls()
	super()
	if awoc_resource_controller.get_material_settings()[ALBEDO]:
		show_new_material_controls()
	else:
		show_material_settings()
