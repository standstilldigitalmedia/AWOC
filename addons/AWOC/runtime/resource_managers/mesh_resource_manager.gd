@tool
class_name AWOCMeshResourceManager
extends Resource

@export var mesh_dictionary: Dictionary
@export var skeleton_resource: AWOCSkeletonResource
var avatar: Node3D

func create_avatar_from_mesh_list(mesh_list: Array[String]) -> void:
	if avatar != null:
		avatar.queue_free()
	avatar = Node3D.new()
	var skeleton: Skeleton3D = skeleton_resource.deserialize_skeleton()
	avatar.add_child(skeleton)
	for mesh_name: String in mesh_list:
		var surface_tool := SurfaceTool.new()
		surface_tool.create_from(mesh_dictionary[mesh_name], 0)
		"""var array_mesh = ArrayMesh.new()
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_dictionary[mesh_name].surface_get_arrays(0))
		var mesh_data_tool = MeshDataTool.new()
		mesh_data_tool.create_from_surface(array_mesh, 0)
		array_mesh.clear_surfaces()
		mesh_data_tool.commit_to_surface(array_mesh)"""
		var new_mesh_instance_3D := MeshInstance3D.new()
		new_mesh_instance_3D.mesh = surface_tool.commit()
		skeleton.add_child(new_mesh_instance_3D)
		new_mesh_instance_3D.skeleton = NodePath("..")
		
		
		
		
		
	
	
	#for mesh_name: String in mesh_list:
		"""var new_mesh_instance := MeshInstance3D.new()
		var array_mesh = ArrayMesh.new()
		var this_mesh: Mesh = mesh_dictionary[mesh_name]
		for surface in this_mesh.get_surface_count():
			array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, this_mesh.surface_get_arrays(surface))
		new_mesh_instance.mesh = array_mesh	"""
		"""var new_mesh_instance := MeshInstance3D.new()
		new_mesh_instance.mesh = mesh_dictionary[mesh_name]
		skeleton.add_child(new_mesh_instance)
		new_mesh_instance.skeleton = NodePath("..")
	avatar.add_child(skeleton)"""
