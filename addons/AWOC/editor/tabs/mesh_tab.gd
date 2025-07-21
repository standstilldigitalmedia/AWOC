@tool
class_name AWOCMeshTab
extends AWOCTabBase

var path_editor := AWOCMeshFileBrowser.new("3D Model File Location", "mesh")


func _init(awoc: AWOCResource, awoc_uid: int) -> void:
	resource_manager = AWOCEditorMeshResourceManager.new()
	resource_manager.init_resource_manager(awoc, awoc_uid, awoc.mesh_manager.mesh_dictionary)
	create_resource_button = AWOCButton.new("Add Mesh(es)")
	super("New Mesh", "Manage Meshes")
		
		
func reset_controls() -> void:
	path_editor.reset_controls()
	super()
	
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(path_editor)
	new_resource_content_vbox.add_child(create_resource_button)
	
	
func set_control_listeners() -> void:
	super()
	path_editor.validated.connect(_on_path_validated)
	
		
func populate_manage_resources() -> void:
	clear_manage_resources_area()
	for mesh_name in resource_manager.get_sorted_name_array():
		var control := AWOCMeshControl.new("Mesh Name",mesh_name, false)
		control.rename.connect(_on_resource_renamed)
		control.delete.connect(_on_resource_deleted)
		manage_resources_content_vbox.add_child(control)
	
	
func _on_path_validated(validated: bool) -> void:
	create_resource_button.disabled = !validated
	
	
func load_avatar(path: String) -> Node3D:
	var avatar_file = load(path)
	return avatar_file.instantiate()


func _on_create_resource_button_pressed() -> void:
	var avatar: Node3D = load_avatar(path_editor.get_asset_path())
	var skeleton: Skeleton3D = resource_manager.add_skeleton(avatar)
	for child in skeleton.get_children():
		if child is MeshInstance3D:
			resource_manager.add_mesh(child)
	super()
