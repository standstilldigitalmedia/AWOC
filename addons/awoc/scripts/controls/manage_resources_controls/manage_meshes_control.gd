@tool
class_name AWOCManageMeshesControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var dynamic_character: AWOCDynamicCharacter

func reset_controls():
	preview_control.visible = false
	preview_control.reset()
	if dynamic_character != null:
		dynamic_character.queue_free()
	super()

func _on_show_mesh(mesh_name: String):
	if dynamic_character == null:
		dynamic_character = AWOCDynamicCharacter.new()
		dynamic_character.init_base_dynamic_character(awoc_resource_controller.awoc_resource)
		preview_control.set_subject(dynamic_character)
	dynamic_character.add_mesh_to_list(mesh_name)
	preview_control.visible = true
	
func _on_hide_mesh(mesh_name: String):
	dynamic_character.remove_mesh_from_list(mesh_name)
	if dynamic_character.mesh_dictionary.size() < 1:
		preview_control.visible = false

func populate_resource_controls_area():
	super()
	for mesh_name in awoc_resource_controller.get_meshes_dictionary():
		var mesh_control = AWOCMeshControl.new(awoc_resource_controller, mesh_name)
		mesh_control.controls_reset.connect(emit_controls_reset)
		mesh_control.show_mesh.connect(_on_show_mesh)
		mesh_control.hide_mesh.connect(_on_hide_mesh)
		control_panel_container_vbox.add_child(mesh_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Meshes")
	super()
	
func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	preview_control = preview
	super(awoc_resource_controller.get_meshes_dictionary())
