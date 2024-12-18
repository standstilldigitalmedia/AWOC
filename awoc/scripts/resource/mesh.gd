@tool
class_name AWOCMesh extends AWOCResourceBase

@export var surface_array: Array
@export var original_uv1: Array
@export var original_uv2: Array

func add_mesh_to_surface(surface_tool: SurfaceTool):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for surface in surface_array.size():
		var counter = 0
		for array_counter in surface_array[surface][Mesh.ARRAY_VERTEX].size():
			var bones_array: PackedInt32Array = PackedInt32Array()
			bones_array.append(surface_array[surface][Mesh.ARRAY_BONES][counter])
			bones_array.append(surface_array[surface][Mesh.ARRAY_BONES][counter + 1])
			bones_array.append(surface_array[surface][Mesh.ARRAY_BONES][counter + 2])
			bones_array.append(surface_array[surface][Mesh.ARRAY_BONES][counter + 3])
			surface_tool.set_bones(bones_array)
			surface_tool.set_normal(surface_array[surface][Mesh.ARRAY_NORMAL][array_counter])
			surface_tool.set_uv(surface_array[surface][Mesh.ARRAY_TEX_UV][array_counter])
			surface_tool.set_uv2(surface_array[surface][Mesh.ARRAY_TEX_UV2][array_counter])
			surface_tool.set_weights(surface_array[surface][Mesh.ARRAY_WEIGHTS][array_counter])
			surface_tool.add_vertex(surface_array[surface][Mesh.ARRAY_VERTEX][array_counter])

func restore_original_uvs():
	for surface in surface_array.size():
		surface_array[surface][Mesh.ARRAY_TEX_UV] = original_uv1[surface]
		if surface_array[surface][Mesh.ARRAY_TEX_UV2] != null:
			surface_array[surface][Mesh.ARRAY_TEX_UV2] = original_uv2[surface]

		
"""#set offset to 0 for the left side tile. set offset to 1 or higher for each tile to the right of 0"""
func scale_and_offest_uvs_in_surface_array(num_of_tiles: int, offset: int):
	var increment = 1.0 / float(num_of_tiles)
	for surface in surface_array:
		for uv in surface[Mesh.ARRAY_TEX_UV].size():
			var uv_x_value = surface[Mesh.ARRAY_TEX_UV][uv].x
			uv_x_value = uv_x_value / num_of_tiles
			uv_x_value = uv_x_value + (offset * increment)
			surface[Mesh.ARRAY_TEX_UV][uv].x = uv_x_value
		if surface[Mesh.ARRAY_TEX_UV2] != null:
			for uv2 in surface[Mesh.ARRAY_TEX_UV2].size():
				var uv2_x_value = surface[Mesh.ARRAY_TEX_UV2][uv2].x
				uv2_x_value = uv2_x_value * num_of_tiles
				uv2_x_value = uv2_x_value + (num_of_tiles * offset)
				surface[Mesh.ARRAY_TEX_UV2][uv2].x = uv2_x_value

func serialize_mesh(source_mesh: MeshInstance3D)-> bool:
	var surface_count: int = source_mesh.mesh.get_surface_count()
	if surface_count < 1:
		push_error("No surfaces found in mesh " + source_mesh.name + "\nAWOCMeshRes serialize_mesh")
		return false
	surface_array = []
	original_uv1 = []
	original_uv2 = []
	for a in surface_count:
		var surface_arrays_get: Array = source_mesh.mesh.surface_get_arrays(a)
		if surface_arrays_get == null or surface_arrays_get.size() < 1:
			push_error("surface_get_arrays returned null.\nAWOCMeshRes serialize_mesh")
			return false
		surface_array.append(surface_arrays_get)
		if surface_arrays_get[Mesh.ARRAY_TEX_UV] != null:
			original_uv1.append(surface_arrays_get[Mesh.ARRAY_TEX_UV])
		if surface_arrays_get[Mesh.ARRAY_TEX_UV2] != null:
			original_uv2.append(surface_arrays_get[Mesh.ARRAY_TEX_UV2])
	return true
		
func deserialize_mesh(skeleton: Skeleton3D) -> MeshInstance3D:
	if surface_array == null or surface_array.size() < 1:
		push_error("The mesh resource you are trying to use has not been initilized with mesh data.\nAWOCMeshRes deserialize_mesh")
		return null
	var new_mesh: ArrayMesh = ArrayMesh.new()
	var surface_count = surface_array.size()
	if surface_count < 1:
		push_error("No surfaces found\nAWOCMeshRes deserialize_mesh")
		return null
	for a in surface_count:
		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,surface_array[a])
	var mesh: MeshInstance3D = MeshInstance3D.new()
	skeleton.add_child(mesh)
	mesh.skeleton = NodePath("..")
	mesh.mesh = new_mesh
	return mesh
