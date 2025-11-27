@tool
class_name AWOCEditorMeshManager
extends AWOCEditorDiskResourceManager


func save_skeleton_to_disk(skeleton_node: Skeleton3D, save_path: String) -> String:
	var new_skeleton = skeleton_node.duplicate()
	new_skeleton.position = Vector3.ZERO
	new_skeleton.rotation = Vector3.ZERO
	new_skeleton.scale = Vector3.ONE
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(new_skeleton)
	if result != OK:
		new_skeleton.queue_free()
		return "Error: Could not pack skeleton scene. Error code: " + str(result)
	var dir_created: String = create_dir_for_file_path(save_path)
	if !dir_created.is_empty():
		new_skeleton.queue_free()
		return dir_created
	var save_result = ResourceSaver.save(packed_scene, save_path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	new_skeleton.queue_free()
	if save_result != OK:
		return "Error saving skeleton file. Error code: " + str(save_result)
	await Engine.get_main_loop().process_frame
	var uid = ResourceLoader.get_resource_uid(save_path)
	if uid == ResourceUID.INVALID_ID:
		return "Error: Failed to get UID for skeleton at " + save_path
	var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	resource_reference.set_uid(uid)
	resource_reference.set_path(save_path)
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		return "GlobalState not found"
	awoc_state.current_awoc.skeleton_reference = resource_reference
	return save_parent_resource()


func recursive_get_skeleton(source_obj: Node) -> Skeleton3D:
	if source_obj is Skeleton3D:
		return source_obj
	for child: Node in source_obj.get_children():
		var skele: Skeleton3D = recursive_get_skeleton(child)
		if skele != null:
			return skele
	return null


func create_mesh_asset(mesh_instance: MeshInstance3D) -> String:
	var mesh_name: String = mesh_instance.name
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		return "GlobalState not found"
	var mesh_instance_path: String = awoc_state.current_asset_path + "/meshes/mesh/" + mesh_name + ".res"
	var mesh_resource_path: String = awoc_state.current_asset_path + "/meshes/resource"
	var create_mesh_instance_dir: String = create_dir_for_file_path(mesh_instance_path)
	if !create_mesh_instance_dir.is_empty():
		return create_mesh_instance_dir
	ResourceSaver.save(mesh_instance.mesh, mesh_instance_path)
	var mesh_resource = AWOCMeshResource.new()
	mesh_resource.array_mesh = load(mesh_instance_path)
	return create_resource_on_disk(mesh_resource, mesh_name, mesh_resource_path)


func scan_imported_scene(root_node: Node) -> String:
	var found_skeleton: Skeleton3D = null
	var all_meshes: Array[MeshInstance3D] = []
	var nodes_to_check = [root_node]
	while nodes_to_check.size() > 0:
		var current = nodes_to_check.pop_back()
		if current is Skeleton3D:
			if found_skeleton == null:
				found_skeleton = current
		elif current is MeshInstance3D:
			all_meshes.append(current)
		nodes_to_check.append_array(current.get_children())
	if !found_skeleton:
		return "No Skeleton found!"
	if all_meshes.size() < 1:
		return "No meshes found"
	var valid_skin_meshes: Array[MeshInstance3D] = []
	for mesh_inst in all_meshes:
		var skel_path = mesh_inst.skeleton
		var target_node = mesh_inst.get_node_or_null(skel_path)
		if target_node == found_skeleton:
			valid_skin_meshes.append(mesh_inst)
		else:
			print("Ignored Static Mesh (Not rigged to avatar): ", mesh_inst.name)
	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if !awoc_state:
		return "GlobalState not found"
	var save_skeleton: String = await save_skeleton_to_disk(found_skeleton, awoc_state.current_asset_path + "/skeleton/skeleton.tscn")
	if !save_skeleton.is_empty():
		return save_skeleton
	for mesh: MeshInstance3D in valid_skin_meshes:
		var save_mesh: String = create_mesh_asset(mesh)
		if !save_mesh.is_empty():
			printerr("Failed to save mesh '" + mesh.name + "': " + save_mesh)
	return ""


func add_new_avatar(path: String) -> String:
	if AWOCValidator.is_avatar_file(path):
		var avatar_scene = load(path)
		if !avatar_scene:
			return "Source model file could not be loaded at " + path
		var avatar = avatar_scene.instantiate()
		if !avatar:
			return "Source model file could not be instatiated."
		var skeleton: Skeleton3D = recursive_get_skeleton(avatar)
		if skeleton:
			return await scan_imported_scene(avatar)
		# This will be where we handle meshes that aren't skinned.
		# We'll save this for some other time
	elif AWOCValidator.is_valid_node_path(path):
		# This is where we will handle a single mesh being adding to an existing AWOC.
		# We'll handle this some other time
		pass
	return "Please provide a valid path to a valid source model file."


func create_resource(_resource_name: String, additional_data: Dictionary) -> String:
	return await add_new_avatar(additional_data.get("path"))
