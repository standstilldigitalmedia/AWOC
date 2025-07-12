@tool
class_name AWOCMeshTab
extends AWOCTabBase

var mesh_manager: AWOCEditorMeshResourceManager
var path_editor := AWOCMeshFileBrowser.new("3D Model File Location", "mesh")
var add_meshes_button := AWOCButton.new("Add Mesh(es)")

func _init(awoc: AWOCResource, awoc_uid: int) -> void:
	mesh_manager = AWOCEditorMeshResourceManager.new()
	mesh_manager.init_resource_manager(awoc, awoc_uid, awoc.mesh_manager.mesh_dictionary)
	super("New Mesh", "Manage Meshes")


func set_manage_button_disabled() -> void:
	pass
	"""if slot_manager.get_slot_dictionary().size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)"""
		
		
func reset_controls() -> void:
	#name_line_edit.text = ""
	add_meshes_button.disabled = true
	#populate_manage_slots_area()
	
func reset_tab() -> void:
	super()
	reset_controls()
	set_manage_button_disabled()
		
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(path_editor)
	new_resource_content_vbox.add_child(add_meshes_button)
	
	
func set_control_listeners() -> void:
	super()
	path_editor.validated.connect(_on_path_validated)
	add_meshes_button.pressed.connect(_on_add_meshes_button_pressed)
	
		
func populate_manage_slots_area() -> void:
	clear_manage_resources_area()
	"""for slot_name in slot_manager.get_sorted_name_array():
		var control := AWOCControl.new(slot_name)
		control.rename.connect(_on_slot_renamed)
		control.delete.connect(_on_slot_deleted)
		manage_resources_content_vbox.add_child(control)"""
	
	
func _on_path_validated(validated: bool) -> void:
	add_meshes_button.disabled = !validated
	
	
func load_avatar(path: String) -> Node3D:
	var avatar_file = load(path)
	return avatar_file.instantiate()


func _on_add_meshes_button_pressed() -> void:
	var avatar: Node3D = load_avatar(path_editor.get_asset_path())
	var skeleton: Skeleton3D = mesh_manager.add_skeleton(avatar)
	for child in skeleton.get_children():
		if child is MeshInstance3D:
			mesh_manager.add_mesh(child)
		

	
"""func _on_slot_renamed(old_name: String, new_name: String) -> void:
	slot_manager.rename_slot(old_name, new_name)
	reset_controls()
	
	
func _on_slot_deleted(slot_name) -> void:
	slot_manager.delete_slot(slot_name)
	if slot_manager.get_slot_dictionary().size() > 0:
		reset_controls()
	else:
		reset_tab()"""
	
