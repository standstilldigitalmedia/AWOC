@tool
class_name AWOCRes extends Resource

@export var awoc_name: String
@export var slots_dictionary: Dictionary
@export var source_mesh_list: Dictionary
@export var source_mesh_path: String
var source_avatar_file: Resource
var source_skeleton: Skeleton3D

func recursive_get_skeleton(source_obj: Node):
	if source_obj.is_class("Skeleton3D"):
		return source_obj
	for child in source_obj.get_children():
		var skele = recursive_get_skeleton(child)
		if skele != null:
			return skele
	return null

func serialize_skeleton(source_skeleton: Skeleton3D):
	var dest_skeleton: Array = []
	var bone_count: int = source_skeleton.get_bone_count()
	for a in bone_count:
		var bone: Dictionary = {}
		bone["bone_name"] = source_skeleton.get_bone_name(a)
		bone["global_pose_override"] = source_skeleton.get_bone_global_pose_override(a)
		bone["bone_parent"] = source_skeleton.get_bone_parent(a)
		bone["bone_position"] = source_skeleton.get_bone_pose_position(a)
		bone["bone_scale"] = source_skeleton.get_bone_pose_scale(a)
		bone["bone_rotation"] = source_skeleton.get_bone_pose_rotation(a)
		bone["bone_rest"] = source_skeleton.get_bone_rest(a)
		dest_skeleton.append(bone)
	return dest_skeleton
	
func deserialize_skeleton(source_skeleton: Array):
	var bone_count: int = source_skeleton.size()
	var dest_skeleton: Skeleton3D = Skeleton3D.new()
	for a in bone_count:
		dest_skeleton.add_bone(source_skeleton[a]["bone_name"])
		dest_skeleton.set_bone_global_pose_override(a,source_skeleton[a]["global_pose_override"],1)
		dest_skeleton.set_bone_parent(a, source_skeleton[a]["bone_parent"])
		dest_skeleton.set_bone_pose_position(a, source_skeleton[a]["bone_position"])
		dest_skeleton.set_bone_pose_scale(a, source_skeleton[a]["bone_scale"])
		dest_skeleton.set_bone_pose_rotation(a, source_skeleton[a]["bone_rotation"])
		dest_skeleton.set_bone_rest(a, source_skeleton[a]["bone_rest"])
	return dest_skeleton
	
func serialize_mesh(mesh):
	if mesh.is_class("MeshInstance3D"):
		var mesh_array: Array = []
		var surface_count = mesh.mesh.get_surface_count()
		if surface_count < 1:
			print(mesh.name + " has no surface count")
		for surface in surface_count:
			mesh_array.append(mesh.mesh.surface_get_arrays(surface))
		return mesh_array
	return null
	
func deserialize_mesh(mesh_array: Array, skeleton: Skeleton3D):
	var new_mesh_3d: MeshInstance3D = MeshInstance3D.new()
	skeleton.add_child.call_deferred(new_mesh_3d)
	var new_mesh: ArrayMesh = ArrayMesh.new()
	for array in mesh_array:
		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,array)
	new_mesh_3d.mesh = new_mesh
	new_mesh_3d.set_skeleton_path("..")
	#new_mesh_3d.skeleton = skeleton
	return new_mesh_3d
	
func init_source_avatar():
	if source_avatar_file != null:
		source_avatar_file.queue_free()
	if source_skeleton != null:
		source_skeleton.queue_free()
		
	if source_mesh_path != null and source_mesh_path.length() > 1:
		source_avatar_file = load(source_mesh_path)
		var source_avatar_obj = source_avatar_file.instantiate()
		source_skeleton = recursive_get_skeleton(source_avatar_obj)
		source_mesh_list = {}
		for source_mesh in source_skeleton.get_children():
			if source_mesh.is_class("MeshInstance3D"):
				source_mesh_list[source_mesh.name] = source_mesh
	
func create_awoc_avatar(mesh_list: Array):
	var base_awoc: Node3D = Node3D.new()
	base_awoc.name = awoc_name
	var armature: Node3D = Node3D.new()
	armature.name = "Armature"
	var dest_skeleton: Skeleton3D = deserialize_skeleton(serialize_skeleton(source_skeleton))
	
	for dest_mesh in mesh_list:
		deserialize_mesh(serialize_mesh(source_mesh_list[dest_mesh]), dest_skeleton)
	armature.add_child(dest_skeleton)
	base_awoc.add_child(armature)
	return base_awoc
