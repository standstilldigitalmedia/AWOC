@tool
class_name AWOCBone extends AWOCResourceBase

@export var bone_name: String
@export var global_pose_override: Transform3D
@export var bone_parent: int 
@export var bone_position: Vector3
@export var bone_scale: Vector3
@export var bone_rotation: Quaternion
@export var bone_rest: Transform3D

func serialize_bone(source_skeleton: Skeleton3D, index: int):
	bone_name = source_skeleton.get_bone_name(index)
	global_pose_override = source_skeleton.get_bone_global_pose_override(index)
	bone_parent = source_skeleton.get_bone_parent(index)
	bone_position = source_skeleton.get_bone_pose_position(index)
	bone_scale = source_skeleton.get_bone_pose_scale(index)
	bone_rotation = source_skeleton.get_bone_pose_rotation(index)
	bone_rest = source_skeleton.get_bone_rest(index)
