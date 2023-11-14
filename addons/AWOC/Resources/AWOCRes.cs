using Godot;

namespace AWOC
{
	
	[Tool]
	public partial class AWOCRes : Resource
	{
		[Export] string awocName;
		[Export] public AWOCSlotRes[] slots;
		[Export] public string awocPath;

		public AWOCRes(){}

		public AWOCRes(string awocName, string awocPath)
		{
			this.awocName = awocName;
			this.awocPath = awocPath;
		}

		public void SaveAWOC()
		{
			ResourceSaver.Save(this, awocPath);
		}
		
	}
}



	

	
/*func serialize_mesh(mesh):
	if mesh.is_class("MeshInstance3D"):
		var mesh_array: Array = []
		var surface_count = mesh.mesh.get_surface_count()
		if surface_count < 1:
			print(mesh.name + " has no surface count")
		for surface in surface_count:
			mesh_array.append(mesh.mesh.surface_get_arrays(surface))
		return mesh_array
	return null
	
func deserialize_mesh_list(meshes: Array, skeleton: Skeleton3D):
	var new_mesh: ArrayMesh = ArrayMesh.new()
	for mesh in meshes:
		for surface in mesh:
			new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,surface)
	var new_mesh_3d: MeshInstance3D = MeshInstance3D.new()
	skeleton.add_child.call_deferred(new_mesh_3d)
	new_mesh_3d.mesh = new_mesh
	new_mesh_3d.set_skeleton_path("..")
	return new_mesh_3d
	
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
	
func load_source_avatar():
	if source_skeleton != null:
		source_skeleton.queue_free()
	if source_avatar != null:
		source_avatar.queue_free()
	if source_avatar_file != null:
		var source_avatar = source_avatar_file.instantiate()
		source_skeleton = recursive_get_skeleton(source_avatar)
		source_mesh_list = {}
		for source_mesh in source_skeleton.get_children():
			if source_mesh.is_class("MeshInstance3D"):
				source_mesh_list[source_mesh.name] = source_mesh
	
func init_source_avatar(path: String):
	source_avatar_file = load(path)
	load_source_avatar()
	
func create_awoc_avatar(mesh_list: Array):
	var base_awoc: Node3D = Node3D.new()
	base_awoc.name = awoc_name
	var armature: Node3D = Node3D.new()
	armature.name = "Armature"
	var dest_skeleton: Skeleton3D = deserialize_skeleton(serialize_skeleton(source_skeleton))
	var source_meshes: Array = []
	for mesh in mesh_list:
		source_meshes.append(serialize_mesh(source_mesh_list[mesh]))
	deserialize_mesh_list(source_meshes, dest_skeleton)
	
	armature.add_child(dest_skeleton)
	base_awoc.add_child(armature)
	return base_awoc*/

