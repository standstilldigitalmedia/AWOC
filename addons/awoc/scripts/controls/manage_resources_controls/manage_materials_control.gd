@tool
class_name AWOCManageMaterialsControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController

func populate_resource_controls_area():
	super()
	for material_name in awoc_resource_controller.get_materials_dictionary():
		var material_control = AWOCMaterialControl.new(awoc_resource_controller,material_name)
		material_control.control_reset.connect(emit_control_reset)
		control_panel_container_vbox.add_child(material_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Materials")
	super()
	
func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super(awoc_resource_controller.get_materials_dictionary())
