using Godot;
using Godot.Collections;
using System;

namespace AWOC
{
	public class SerializedBone
	{
		public Skeleton3D sourceSkeleton;
		public string boneName;
		public Transform3D globalPoseOverride;
		public int boneParent;
		public Vector3 bonePosition;
		public Vector3 boneScale;
		public Quaternion boneRotation;
		public Transform3D boneRest;

		public SerializedBone(Skeleton3D sourceSkeleton, int index)
		{
			this.sourceSkeleton = sourceSkeleton;
			boneName = sourceSkeleton.GetBoneName(index);
			globalPoseOverride = sourceSkeleton.GetBoneGlobalPoseOverride(index);
			boneParent = sourceSkeleton.GetBoneParent(index);
			bonePosition = sourceSkeleton.GetBonePosePosition(index);
			boneScale = sourceSkeleton.GetBonePoseScale(index);
			boneRotation = sourceSkeleton.GetBonePoseRotation(index);
			boneRest = sourceSkeleton.GetBoneRest(index);
		}
	}
	[Tool]
	public partial class AWOCRes : Resource
	{
		[Export] public string awocName;
		[Export] Dictionary<string,string> slotsDictionary;
		[Export] Dictionary<string, MeshInstance3D> sourceMeshList;
		Skeleton3D sourceSkeleton;
		[Export] Resource sourceAvatarFile;
		[Export] Node3D sourceAvatar;
		[Export] Dictionary<string,MaterialRes> materialsDictionary;

		public AWOCRes(string awocName)
		{
			this.awocName = awocName;
		}

		Skeleton3D RecursiveGetSkeleton(Node3D soureceObj)
		{
			if(soureceObj.IsClass("Skeleton3D"))
				return (Skeleton3D)soureceObj;

			foreach(Node3D child in soureceObj.GetChildren())
			{
				Skeleton3D skele = RecursiveGetSkeleton(child);
				if(skele != null)
					return skele;
			}
			return null;
		}

		SerializedBone[] SerializeSkeleton(Skeleton3D source_skeleton)
		{
			int boneCount = source_skeleton.GetBoneCount();
			SerializedBone[] destSkeleton = new SerializedBone[boneCount];
			for(int a = 0; a < boneCount; a++)
			{
				SerializedBone newBone = new SerializedBone(source_skeleton, a);
				destSkeleton[a] = newBone;
			}
			return destSkeleton;
		}

		Skeleton3D DeserializeSkeleton(SerializedBone[] serializedSkeleton)
		{
			int boneCount = serializedSkeleton.Length;
			Skeleton3D destSkeleton = new Skeleton3D();
			for(int a = 0; a < boneCount; a++)
			{
				destSkeleton.AddBone(serializedSkeleton[a].boneName);
				destSkeleton.SetBoneGlobalPoseOverride(a,serializedSkeleton[a].globalPoseOverride,1);
				destSkeleton.SetBoneParent(a, serializedSkeleton[a].boneParent);
				destSkeleton.SetBonePosePosition(a, serializedSkeleton[a].bonePosition);
				destSkeleton.SetBonePoseScale(a, serializedSkeleton[a].boneScale);
				destSkeleton.SetBonePoseRotation(a, serializedSkeleton[a].boneRotation);
				destSkeleton.SetBoneRest(a, serializedSkeleton[a].boneRest);
			}
			return destSkeleton;
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

