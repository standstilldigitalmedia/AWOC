@tool
class_name AWOCManageOverlaysControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var material_name: String

func set_tab_button_disabled():
	var mat: AWOCMaterial = awoc_resource_controller.get_material_by_name(material_name)
	if mat.overlays_dictionary.size() > 0:
		tab_button.disabled = false
	else:
		tab_button.disabled = true
		hide_control_panel_container()

func populate_resource_controls_area():
	super()
	var mat: AWOCMaterial = awoc_resource_controller.get_material_by_name(material_name)
	for overlay_name in mat.overlays_dictionary:
		var overlay_control = AWOCOverlayControl.new(awoc_resource_controller, material_name, overlay_name)
		overlay_control.controls_reset.connect(emit_controls_reset)
		control_panel_container_vbox.add_child(overlay_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Overlays")
	super()
	
func _init(a_resource_controller: AWOCResourceController, mat_name: String):
	awoc_resource_controller = a_resource_controller
	material_name = mat_name
	create_controls()
	parent_controls()
	reset_controls()
	hide_control_panel_container()
