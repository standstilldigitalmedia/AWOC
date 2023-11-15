using Godot;
using System.Collections.Generic;
using System;
using System.Linq;

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
    public partial class AWOCAvatarRes : Resource
    {
        [Export] string avatarName;
        [Export] PackedScene sourceAvatarRes;
        Skeleton3D sourceSkeleton;
        Skeleton3D destSkeleton;
        public Dictionary<string, MeshInstance3D> sourceMeshList;

        public AWOCAvatarRes()
        {
            avatarName = "empty";
        }

        public AWOCAvatarRes(string avatarName, PackedScene sourceAvatar)
        {
            this.avatarName = avatarName;
            sourceAvatarRes = sourceAvatar;
        }

        Skeleton3D RecursiveGetSkeleton(Node soureceObj)
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

        Godot.Collections.Array[] SerializeMesh(MeshInstance3D mesh)
        {
            int surfaceCount = mesh.Mesh.GetSurfaceCount();
            Godot.Collections.Array[] newMeshArray = new Godot.Collections.Array[surfaceCount];
            for(int a = 0; a < surfaceCount; a++)
            {
                newMeshArray[a] = mesh.Mesh.SurfaceGetArrays(a);
            }
            return newMeshArray;
        }

        MeshInstance3D DeserializeMeshList(List<Godot.Collections.Array[]> meshList, Skeleton3D skeleton)
        {
            ArrayMesh newMesh = new ArrayMesh();
            foreach(Godot.Collections.Array[] mesh in meshList)
            {
                foreach(Godot.Collections.Array surface in mesh)
                {
                    newMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, surface);
                }
            }
            MeshInstance3D newMesh3d = new MeshInstance3D();
            skeleton.AddChild(newMesh3d);
            newMesh3d.Mesh = newMesh;
            newMesh3d.Skeleton = new NodePath("..");
            return newMesh3d;
        }

        public void InitAvatar()
        {
            if(sourceSkeleton != null)
            {
                sourceSkeleton.QueueFree();
                sourceSkeleton = null;
            }
                
            sourceMeshList = new Dictionary<string, MeshInstance3D>();
            Node sourceAvatar = sourceAvatarRes.Instantiate();
            sourceSkeleton = RecursiveGetSkeleton(sourceAvatar);
            foreach(var child in sourceSkeleton.GetChildren())
            {
                if(child is MeshInstance3D)
                {
                    sourceMeshList.Add(child.Name, (MeshInstance3D)child);
                }
            }
        }

        public Node3D CreateAWOCAvatar(string[] meshList)
        {
            Node3D baseAWOC = new Node3D();
            Node3D armature = new Node3D();
            Skeleton3D destSkeleton = DeserializeSkeleton(SerializeSkeleton(sourceSkeleton));

            List<Godot.Collections.Array[]> sourceMeshes = new List<Godot.Collections.Array[]>();
            for(int a = 0; a < meshList.Length; a++)
            {
                sourceMeshes.Add(SerializeMesh(sourceMeshList[meshList[a]]));
            }
            DeserializeMeshList(sourceMeshes, destSkeleton);
            armature.AddChild(destSkeleton);
            baseAWOC.AddChild(armature);
            return baseAWOC;
        }

        public override bool Equals(Object obj)
        {			
            if(GetHashCode() == obj.GetHashCode())
                return true;
            return false;
        }

        public override int GetHashCode()
        {
            string replaced = string.Empty;
            string stringToHash = avatarName + "AvatarRes";
            string stringToHashUpper = stringToHash.ToUpper();
            foreach (char c in stringToHashUpper)
            {
                if (char.IsDigit(c))
                    replaced += c;
                else if (char.IsLetter(c))  
                {
                    int asc = (int)c - (int)'A' + 1;
                    replaced += asc;
                }
            } 
            Int32.TryParse(replaced, out int j);
            return j;
        }
    }
}
		/*
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
	
	/*if mesh.is_class("MeshInstance3D"):
		var mesh_array: Array = []
		var surface_count = 
		if surface_count < 1:
			print(mesh.name + " has no surface count")
		for surface in surface_count:
			mesh_array.append(mesh.mesh.surface_get_arrays(surface))
		return mesh_array
	return null

		/*
	
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
	

	
func init_source_avatar(path: String):
	source_avatar_file = load(path)
	load_source_avatar()
	
*/