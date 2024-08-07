class_name AWOCAvatar extends Resource

@export var skeleton_uid: int
@export var mesh_uids_dictionary: Dictionary

var avatar: Node3D
var skeleton: Skeleton3D
var mesh_dictionary: Dictionary

func serialize_all_meshes(source_skeleton: Skeleton3D, avatar_path: String):
	if !Engine.is_editor_hint():
		return
	if source_skeleton.get_child_count() < 1:
		push_error("No mesh children found in source skeleton.\nAWOCAvatarRes serialize_meshes")
		return
	var found: bool = false
	for mesh in source_skeleton.get_children():
		if mesh is MeshInstance3D:
			found = true
			var mesh_res: AWOCMesh = AWOCMesh.new()
			mesh_res.serialize_mesh(mesh)
			var mesh_path = avatar_path + "/" + mesh.name + ".res"
			if !mesh_path.is_absolute_path():
				push_error("Invalid mesh path\nAWOCAvatarRes serialize_meshes")
				return
			var save_mesh: Error = ResourceSaver.save(mesh_res, mesh_path)
			if save_mesh != OK:
				push_error("Save mesh failed. ResourceSaver.save Error: " + str(save_mesh) + "\nAWOCAvatarRes serialize_meshes")
				return
			var mesh_uid: int = ResourceLoader.get_resource_uid(mesh_path)
			if mesh_uid == -1:
				push_error("Mesh ID not found.\nAWOCAvatarRes serialize_meshes")
				return
			mesh_uids_dictionary[mesh.name] = mesh_uid
	if !found:
		push_error("No meshes found in source skeleton.\nAWOCAvatarRes serialize_meshes")
		return

func create_avatar_from_mesh_name_array(mesh_name_array: Array) -> Node3D:
	var node = Node3D.new()
	var skeleton_resource = load(ResourceUID.get_id_path(skeleton_uid))
	var skeleton: Skeleton3D = skeleton_resource.deserialize_skeleton()
	for mesh_name in mesh_name_array:
		var mesh_resource = load(ResourceUID.get_id_path(mesh_uids_dictionary[mesh_name]))
		mesh_resource.deserialize_mesh(skeleton)
	node.add_child(skeleton)
	return node
	
func add_mesh_to_skeleton(mesh_to_add: String):
	if !mesh_uids_dictionary.has(mesh_to_add):
		push_error("Mesh ID dictionary does not contain " + mesh_to_add + "\nAWOCAvatarRes add_mesh_to_skeleton")
		return
	if skeleton == null:
		push_error("Skeleton has not been instantiated\nAWOCAvatarRes add_mesh_to_skeleton")
		return
	var mesh_res: AWOCMesh
	if Engine.is_editor_hint():
		mesh_res = load(ResourceUID.get_id_path(mesh_uids_dictionary[mesh_to_add]))
	else:
		mesh_res = load(mesh_uids_dictionary[mesh_to_add].path)
	if mesh_res == null:
		push_error("AWOCMeshRes not loaded.\nAWOCAvatarRes add_mesh_to_skeleton")
		return
	var de_mesh = mesh_res.deserialize_mesh(skeleton)
	mesh_dictionary[mesh_to_add] = mesh_res.mesh
	
func delete_mesh_from_skeleton(mesh_to_delete: String):
	if !mesh_dictionary.has(mesh_to_delete):
		return
	mesh_dictionary[mesh_to_delete].queue_free()
	mesh_dictionary.erase(mesh_to_delete)

func serialize_meshes(source_skeleton: Skeleton3D, avatar_path: String):
	if !Engine.is_editor_hint():
		return
	if source_skeleton.get_child_count() < 1:
		push_error("No mesh children found in source skeleton.\nAWOCAvatarRes serialize_meshes")
		return
	var found: bool = false
	for mesh in source_skeleton.get_children():
		if mesh is MeshInstance3D:
			found = true
			var mesh_res: AWOCMesh = AWOCMesh.new()
			mesh_res.serialize_mesh(mesh)
			var mesh_path = avatar_path + "/" + mesh.name + ".res"
			if !mesh_path.is_absolute_path():
				push_error("Invalid mesh path\nAWOCAvatarRes serialize_meshes")
				return
			var save_mesh: Error = ResourceSaver.save(mesh_res, mesh_path)
			if save_mesh != OK:
				push_error("Save mesh failed. ResourceSaver.save Error: " + str(save_mesh) + "\nAWOCAvatarRes serialize_meshes")
				return
			var mesh_uid: int = ResourceLoader.get_resource_uid(mesh_path)
			if mesh_uid == -1:
				push_error("Mesh ID not found.\nAWOCAvatarRes serialize_meshes")
				return
			mesh_uids_dictionary[mesh.name] = mesh_uid
	if !found:
		push_error("No meshes found in source skeleton.\nAWOCAvatarRes serialize_meshes")
		return
		
func init_avatar():
	avatar = Node3D.new()
	avatar.position = Vector3.ZERO
	avatar.rotation = Vector3.ZERO
	avatar.scale = Vector3.ONE
	
func deserialize_skeleton():
	var skeleton_res: AWOCSkeleton
	if skeleton_uid == null or skeleton_uid < 1:
		push_error("No id found for AWOCSkeletonRes.\nAWOCAvatarRes deserialize_skeleton")
		return
	skeleton_res = load(ResourceUID.get_id_path(skeleton_uid))
	if skeleton_res == null:
		push_error("AWOCSkeletonRes could not be loaded.\nAWOCAvatarRes deserialize_skeleton")
		return
	skeleton_res.deserialize_skeleton()
	skeleton = skeleton_res.skeleton
	
func serialize_avatar(source_obj: Node, path: String):
	if !Engine.is_editor_hint():
		return
	if path.length() < 4:
		push_error("Please enter a path that is longer than 3 characters.")
		return
	var source_skeleton: Skeleton3D# = AWOCSkeleton.recursive_get_skeleton(source_obj)
	if source_skeleton == null:
		push_error("Skeleton not found in source node.\nAWOCAvatarRes serialize_avatar")
		return
	var avatar_path: String = path + "/Avatar"
	var skeleton_path: String = avatar_path + "/skeleton.res"
	#create_avatar_directory(path, avatar_path)
	#create_skeleton_res(skeleton_path, source_skeleton)
	serialize_meshes(source_skeleton, avatar_path)
	
func deserialize_avatar(mesh_list: Array):
	init_avatar()
	var de_skele = deserialize_skeleton()
	avatar.add_child(skeleton)
	for mesh_name in mesh_list:
		var mesh_res: AWOCMesh
		#if Engine.is_editor_hint():
		mesh_res = load(ResourceUID.get_id_path(mesh_uids_dictionary[mesh_name]))
		#else:
			#mesh_res = load(mesh_res_container_dict[mesh_name].path)
		if mesh_res == null:
			push_error("AWOCMeshRes not loaded.\nAWOCAvatarRes deserialize_avatar")
			return
		mesh_res.deserialize_mesh(skeleton)
		mesh_dictionary[mesh_name] = mesh_res.mesh
