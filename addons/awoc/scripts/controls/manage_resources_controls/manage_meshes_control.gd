@tool
class_name AWOCManageMeshesControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var mesh_list: Array

func reset_controls():
	preview_control.visible = false
	mesh_list = Array()
	super()

func _on_show_mesh(mesh_name: String):
	mesh_list.append(mesh_name)
	preview_control.set_subject(awoc_resource_controller.instatiate_avatar_from_mesh_list(mesh_list))
	preview_control.visible = true
	
func _on_hide_mesh(mesh_name: String):
	mesh_list.erase(mesh_name)
	if mesh_list.size() < 1:
		preview_control.set_subject(null)
		preview_control.visible = false
	else:
		preview_control.set_subject(awoc_resource_controller.instatiate_avatar_from_mesh_list(mesh_list))

func populate_resource_controls_area():
	super()
	for mesh_name in awoc_resource_controller.get_meshes_dictionary():
		var mesh_control = AWOCMeshControl.new(awoc_resource_controller, mesh_name)
		mesh_control.control_reset.connect(emit_control_reset)
		mesh_control.show_mesh.connect(_on_show_mesh)
		mesh_control.hide_mesh.connect(_on_hide_mesh)
		control_panel_container_vbox.add_child(mesh_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Meshes")
	super()
	
func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	preview_control = preview
	mesh_list = Array()
	super(awoc_resource_controller.get_meshes_dictionary())
