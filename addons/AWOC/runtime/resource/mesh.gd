@tool
class_name AWOCMeshResource
extends Resource

@export var array_mesh: ArrayMesh


func is_valid() -> bool:
	return array_mesh != null
