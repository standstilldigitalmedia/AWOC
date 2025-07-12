@tool
class_name AWOCEditorMeshResourceManager
extends AWOCEditorDictionaryResourceManager


func add_skeleton(avatar: Node3D) -> Skeleton3D:
	var skeleton: Skeleton3D = recursive_get_skeleton(avatar)
	var skeleton_resource := AWOCSkeletonResource.new()
	skeleton_resource.serialize_skeleton(skeleton)
	parent_resource.mesh_manager.skeleton_resource = skeleton_resource
	save_parent_resource()
	return skeleton
	
	
func add_mesh(mesh_instance_3d: MeshInstance3D) -> void:
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_instance_3d.mesh.surface_get_arrays(0))
	var mesh_data_tool = MeshDataTool.new()
	mesh_data_tool.create_from_surface(array_mesh, 0)
	array_mesh.clear_surfaces()
	mesh_data_tool.commit_to_surface(array_mesh)

	"""var array_mesh = ArrayMesh.new()
	for surface in mesh_instance_3d.mesh.get_surface_count():
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_instance_3d.mesh.surface_get_arrays(surface))
	var new_mesh_instance = MeshInstance3D.new()
	new_mesh_instance.mesh = array_mesh"""	
	add_resource_to_dictionary(mesh_instance_3d.name, array_mesh)
	save_parent_resource()
	

func delete_mesh(res_name: String) -> void:
	delete_resource_from_dictionary(res_name)
	save_parent_resource()
	
	
func rename_mesh(old_name: String, new_name: String) -> void:
	rename_resource_in_dictionary(old_name, new_name)
	save_parent_resource()
	
	
func get_dictionary() -> Dictionary:
	return parent_resource.mesh_dictionary
	
	
func recursive_get_skeleton(sourceObj: Node) -> Skeleton3D:
	if sourceObj is Skeleton3D:
		return sourceObj
	for child: Node in sourceObj.get_children():
		var skele: Skeleton3D = recursive_get_skeleton(child)
		if skele != null:
			return skele	
	return null
