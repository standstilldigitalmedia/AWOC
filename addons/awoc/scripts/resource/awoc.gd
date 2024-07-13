class_name AWOC extends AWOCResourceBase

@export var slots_dictionary: Dictionary
@export var skeleton_uid: int
@export var meshes_uid_dictionary: Dictionary

func get_asset_creation_path() -> String:
	return ResourceUID.get_id_path(uid).get_base_dir()

func create_avatar_from_mesh_name_array(mesh_name_array: Array) -> Node3D:
	var node = Node3D.new()
	var skeleton_resource = load(ResourceUID.get_id_path(skeleton_uid))
	var skeleton: Skeleton3D = skeleton_resource.deserialize_skeleton()
	for mesh_name in mesh_name_array:
		var mesh_resource = load(ResourceUID.get_id_path(meshes_uid_dictionary[mesh_name]))
		mesh_resource.deserialize_mesh(skeleton)
	node.add_child(skeleton)
	return node
