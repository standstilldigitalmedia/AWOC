@tool
class_name AWOCSkeleton extends AWOCResourceBase

@export var bones: Array

func recursive_get_skeleton(sourceObj: Node) -> Skeleton3D:
	if sourceObj is Skeleton3D:
		return sourceObj
	for child: Node in sourceObj.get_children():
		var skele: Skeleton3D = recursive_get_skeleton(child)
		if skele != null:
			return skele	
	return null

func serialize_skeleton(source_skeleton: Skeleton3D):
	var bone_count = source_skeleton.get_bone_count()
	if bone_count < 1:
		push_error("Source skeleton does not have any bones\nAWOCSkeletonRes serialize_skeleton")
		return 		
	bones = []
	for a in bone_count:
		var bone_res: AWOCBone = AWOCBone.new()
		bone_res.serialize_bone(source_skeleton, a)
		bones.append(bone_res)
	
func deserialize_skeleton() -> Skeleton3D:
	if bones == null or bones.size() < 1:
		push_error("Skeleton resource does not have any bones\n AWOCSkeletonRes deserialize_skeleton")
		return null	
	var bone_count: int = bones.size()
	var skeleton: Skeleton3D = Skeleton3D.new()
	for a in bone_count:
		skeleton.add_bone(bones[a].bone_name)	
		skeleton.set_bone_global_pose_override(a, bones[a].global_pose_override,1)
		skeleton.set_bone_parent(a, bones[a].bone_parent)
		skeleton.set_bone_pose_position(a, bones[a].bone_position)
		skeleton.set_bone_pose_scale(a, bones[a].bone_scale)
		skeleton.set_bone_pose_rotation(a, bones[a].bone_rotation)
		skeleton.set_bone_rest(a, bones[a].bone_rest)
	return skeleton
