using Godot;
using System.Collections.Generic;

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
	public partial class AWOCMeshRes : Resource
	{
		Dictionary<string, MeshInstance3D> sourceMeshList;
		Skeleton3D sourceSkeleton;
		[Export] Resource sourceAvatarFile;
		[Export] Node3D sourceAvatar;
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