@tool
class_name AWOCMeshController
extends AWOCResourceControllerBase


func _get_dictionary() -> Dictionary[String, AWOCResourceReference]:
	return _awoc_reference.load_res().mesh_dictionary
	
	
func serialize_mesh(source_mesh: MeshInstance3D)-> AWOCMesh:
	var surface_count: int = source_mesh.mesh.get_surface_count()
	var awoc_mesh: AWOCMesh = AWOCMesh.new()
	if surface_count < 1:
		push_error("No surfaces found in mesh " + source_mesh.name + "\nAWOCMeshRes serialize_mesh")
		return null
	awoc_mesh.surface_array = []
	awoc_mesh.original_uv1 = []
	awoc_mesh.original_uv2 = []
	for a in surface_count:
		var surface_arrays_get: Array = source_mesh.mesh.surface_get_arrays(a)
		if surface_arrays_get == null or surface_arrays_get.size() < 1:
			push_error("surface_get_arrays returned null.\nAWOCMeshRes serialize_mesh")
			return null
		awoc_mesh.surface_array.append(surface_arrays_get)
		if surface_arrays_get[Mesh.ARRAY_TEX_UV] != null:
			awoc_mesh.original_uv1.append(surface_arrays_get[Mesh.ARRAY_TEX_UV])
		if surface_arrays_get[Mesh.ARRAY_TEX_UV2] != null:
			awoc_mesh.original_uv2.append(surface_arrays_get[Mesh.ARRAY_TEX_UV2])
	return awoc_mesh
	
	
func serialize_skeleton(source_skeleton: Skeleton3D, awoc_skeleton: AWOCSkeleton) -> bool:
	var bone_count = source_skeleton.get_bone_count()
	if bone_count < 1:
		push_error("Source skeleton does not have any bones\nAWOCSkeletonRes serialize_skeleton")
		return 	false	
	awoc_skeleton.bones = []
	for a in bone_count:
		var bone_res: AWOCBone = AWOCBone.new()
		bone_res.serialize_bone(source_skeleton, a)
		awoc_skeleton.bones.append(bone_res)
	return true
	
	
func create_avatar_files(avatar_file_path: String) -> bool:
	var avatar_scene = load(avatar_file_path)
	if !avatar_scene:
		printerr("Avatar could not be loaded")
		return false
	var avatar = avatar_scene.instantiate()
	if !avatar:
		printerr("Avatar could not be intantiated")
		return false
	var awoc_skeleton: AWOCSkeleton = AWOCSkeleton.new()
	var skeleton: Skeleton3D = awoc_skeleton.recursive_get_skeleton(avatar)
	if !serialize_skeleton(skeleton, awoc_skeleton):
		printerr("Skeleton could not be serialized")
		return false
	var skeleton_reference: AWOCResourceReference = AWOCResourceReference.new()
	var editor_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(skeleton_reference)
	editor_reference.set_res(awoc_skeleton)
	editor_reference.set_res_path(_awoc_reference.get_res_path().get_base_dir() + "/skeleton/skeleton.res")
	editor_reference.save_res()
	_awoc_reference.load_res().skeleton_reference = skeleton_reference
	for child in skeleton.get_children():
		if child is MeshInstance3D:
			var awoc_mesh: AWOCMesh = serialize_mesh(child)
			var mesh_reference: AWOCResourceReference = AWOCResourceReference.new()
			var mesh_editor_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(mesh_reference)
			mesh_editor_reference.set_res(awoc_mesh)
			mesh_editor_reference.set_res_path(_awoc_reference.get_res_path().get_base_dir() + "/meshes/" + child.name + ".res")
			mesh_editor_reference.save_res()
			_awoc_reference.load_res().mesh_dictionary[child.name] = mesh_reference
	_awoc_reference.save_res()
	scan()
	return true
