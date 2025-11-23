@tool
class_name AWOCMeshResource
extends Resource

@export var array_mesh: ArrayMesh
@export var position_offset: Vector3 = Vector3.ZERO
@export var rotation_offset: Vector3 = Vector3.ZERO
@export var scale_offset: Vector3 = Vector3.ONE


func is_valid() -> bool:
	return array_mesh != null
