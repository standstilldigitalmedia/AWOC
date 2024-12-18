@tool
class_name AWOCMeshTab
extends AWOCTabBase


func _init(awoc_reference: AWOCEditorResourceReference) -> void:
	_resource_controller = AWOCMeshController.new(awoc_reference)
	super()


func _create_controls() -> void:
	super()
	_new_resource_button = create_toggle_text_button("New Mesh")
	_manage_resources_button = create_toggle_text_button("Manage Meshes")
	_new_resource_control = AWOCNewMeshControl.new()
	
	
func _set_listeners() -> void:
	super()
	_new_resource_control.new_resource.connect(_on_new_resource)


func _on_new_resource(path: String, single_mesh: bool) -> void:
	if single_mesh:
		printerr("single mesh")
		pass
	else:
		_resource_controller.create_avatar_files(path)
	set_manage_resources_button_disabled()
	populate_manage_controls()
	

func populate_manage_controls() -> void:
	super()
	for resource_name: String in _resource_controller._get_dictionary():
		var resource_control: AWOCManageMeshControl = AWOCManageMeshControl.new(resource_name)
		add_manage_resource_control_and_set_listeners(resource_control)
