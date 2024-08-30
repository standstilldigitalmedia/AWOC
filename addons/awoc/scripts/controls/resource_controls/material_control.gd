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

func _on_delete_confirmed():
	awoc_resource_controller.remove_material(material_name)
	control_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_material(material_name, name_line_edit.text)
	control_reset.emit()
	
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
	overlays_panel_container.visible = true
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	overlays_panel_container.visible = false

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
	overlays_tab = AWOCOverlaysTab.new(awoc_resource_controller.get_slots_dictionary())
	overlays_panel_container = create_simi_transparent_panel_container()
	overlays_panel_container.visible = false
	super()
	
func parent_controls():
	var overlays_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	var vbox = create_vbox(0)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	overlays_panel_container.add_child(overlays_panel_margin_container)
	overlays_panel_margin_container.add_child(overlays_tab)
	vbox.add_child(hbox)
	vbox.add_child(overlays_panel_container)
	add_child(vbox)
	super()

func _init(a_controller: AWOCResourceController, m_name: String):
	awoc_resource_controller = a_controller
	material_name = m_name
	super()
