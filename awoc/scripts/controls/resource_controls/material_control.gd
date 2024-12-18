@tool
class_name AWOCMaterialControl extends AWOCResourceControlBase

var awoc_resource_controller: AWOCResourceController
var material_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var hide_button: Button
var show_button: Button
var rename_confimation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog
var overlays_tab: AWOCOverlaysTab
var overlays_panel_container: PanelContainer
var overlays_panel_vbox_container: VBoxContainer
var albedo_image_control: AWOCImageControl
var orm_image_control: AWOCImageControl
var occlusion_image_control: AWOCImageControl
var roughness_image_control: AWOCImageControl
var metallic_image_control: AWOCImageControl

func _on_delete_confirmed():
	awoc_resource_controller.remove_material(material_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_material(material_name, name_line_edit.text)
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
	if albedo_image_control == null:
		create_image_controls()
		parent_image_controls()
	show_button.visible = false
	hide_button.visible = true
	overlays_panel_container.visible = true
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	overlays_panel_container.visible = false
	
func validate_albedo_image():
	if is_image_file(albedo_image_control.path_line_edit.text):
		awoc_resource_controller.change_material_image(material_name,"albedo",albedo_image_control.path_line_edit.text)
		
func validate_orm_image():
	if is_image_file(orm_image_control.path_line_edit.text):
		awoc_resource_controller.change_material_image(material_name,"orm",orm_image_control.path_line_edit.text)
		
func validate_occlusion_image():
	if is_image_file(occlusion_image_control.path_line_edit.text):
		awoc_resource_controller.change_material_image(material_name,"occlusion",occlusion_image_control.path_line_edit.text)
		
func validate_roughness_image():
	if is_image_file(roughness_image_control.path_line_edit.text):
		awoc_resource_controller.change_material_image(material_name,"roughness",roughness_image_control.path_line_edit.text)
		
func validate_metallic_image():
	if is_image_file(metallic_image_control.path_line_edit.text):
		awoc_resource_controller.change_material_image(material_name,"metallic",metallic_image_control.path_line_edit.text)
	
func create_image_controls():
	albedo_image_control = AWOCImageControl.new("Albedo")
	orm_image_control = AWOCImageControl.new("ORM")
	occlusion_image_control = AWOCImageControl.new("Occlusion")
	roughness_image_control = AWOCImageControl.new("Roughness")
	metallic_image_control = AWOCImageControl.new("Metallic")
	albedo_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["albedo"].resource_uid))
	albedo_image_control.path_line_edit.text = ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["albedo"].resource_uid)
	albedo_image_control.validate.connect(validate_albedo_image)
	var material_settings_dictionary: Dictionary = awoc_resource_controller.get_material_settings()
	if material_settings_dictionary["orm"] == true:
		orm_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["orm"].resource_uid))
		orm_image_control.path_line_edit.text = ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["orm"].resource_uid)
		orm_image_control.validate.connect(validate_orm_image)
	if material_settings_dictionary["occlusion"]:
		occlusion_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["occlusion"].resource_uid))
		occlusion_image_control.path_line_edit.text = ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["occlusion"].resource_uid)
		occlusion_image_control.validate.connect(validate_occlusion_image)
	if material_settings_dictionary["roughness"]:
		roughness_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["roughness"].resource_uid))
		roughness_image_control.path_line_edit.text = ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["roughness"].resource_uid)
		roughness_image_control.validate.connect(validate_roughness_image)
	if material_settings_dictionary["metallic"]:
		metallic_image_control.texture_rect.texture = load(ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["metallic"].resource_uid))
		metallic_image_control.path_line_edit.text = ResourceUID.get_id_path(awoc_resource_controller.awoc_resource.get_material_by_name(material_name).image_dictionary["metallic"].resource_uid)
		metallic_image_control.validate.connect(validate_metallic_image)
		
func parent_image_controls():
	var material_settings_dictionary: Dictionary = awoc_resource_controller.get_material_settings()
	overlays_panel_vbox_container.add_child(albedo_image_control)
	if material_settings_dictionary["orm"]:
		overlays_panel_vbox_container.add_child(orm_image_control)
	if material_settings_dictionary["occlusion"]:
		overlays_panel_vbox_container.add_child(occlusion_image_control)
	if material_settings_dictionary["roughness"]:
		overlays_panel_vbox_container.add_child(roughness_image_control)
	if material_settings_dictionary["metallic"]:
		overlays_panel_vbox_container.add_child(metallic_image_control)
	overlays_panel_vbox_container.add_child(overlays_tab)
	
func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit("Material Name", material_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false
	rename_confimation_dialog = create_rename_confirmation_dialog(material_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(material_name)
	overlays_tab = AWOCOverlaysTab.new(material_name, awoc_resource_controller.get_material_by_name(material_name).overlays_dictionary, awoc_resource_controller)
	overlays_panel_container = create_simi_transparent_panel_container()
	overlays_panel_container.visible = false
	super()
	
func parent_controls():
	var overlays_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	overlays_panel_vbox_container = create_vbox(5)
	var vbox = create_vbox(0)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	overlays_panel_margin_container.add_child(overlays_panel_vbox_container)
	overlays_panel_container.add_child(overlays_panel_margin_container)
	vbox.add_child(hbox)
	vbox.add_child(overlays_panel_container)
	add_child(vbox)
	super()

func _init(a_controller: AWOCResourceController, m_name: String):
	awoc_resource_controller = a_controller
	material_name = m_name
	super()
