@tool
class_name AWOCAvatar
extends Node3D

var awoc_resource: AWOCResource
var active_skeleton: Skeleton3D = null
var equipped_meshes: Dictionary = {}  # Key: String (Mesh Name), Value: MeshInstance3D


func initialize_avatar(resource: AWOCResource) -> void:
	if active_skeleton:
		active_skeleton.queue_free()
		active_skeleton = null
	for mesh in equipped_meshes.values():
		if is_instance_valid(mesh):
			mesh.queue_free()
	equipped_meshes.clear()
	awoc_resource = resource
	if not awoc_resource.skeleton_reference:
		printerr("AWOCAvatar: No skeleton reference found in resource.")
		return
	var loaded_resource = awoc_resource.skeleton_reference.load_resource()
	var skel_scene = loaded_resource as PackedScene
	if not skel_scene:
		printerr("AWOCAvatar: Failed to load skeleton scene.")
		return
	active_skeleton = skel_scene.instantiate() as Skeleton3D
	if not active_skeleton:
		printerr("AWOCAvatar: PackedScene instantiated but is not a Skeleton3D")
		return
	add_child(active_skeleton)
	# Preserve the skeleton's transform from the saved scene
	# Don't reset position/rotation as it may contain important orientation data


func toggle_mesh(mesh_name: String, show: bool) -> void:
	if show:
		_equip_mesh(mesh_name)
	else:
		_unequip_mesh(mesh_name)


func _equip_mesh(mesh_name: String) -> void:
	if not active_skeleton:
		printerr("AWOCAvatar: Cannot equip mesh, no skeleton initialized.")
		return
	if equipped_meshes.has(mesh_name):
		return  
	if not awoc_resource.mesh_dictionary.has(mesh_name):
		printerr("AWOCAvatar: Mesh not found in dictionary: " + mesh_name)
		return
	var mesh_ref = awoc_resource.mesh_dictionary[mesh_name]
	var item_wrapper = mesh_ref
	if mesh_ref is AWOCResourceReference:
		item_wrapper = mesh_ref.load_resource()
	if not item_wrapper or not item_wrapper is AWOCMeshResource:
		printerr("AWOCAvatar: Failed to load AWOCMeshResource for " + mesh_name)
		return
	var geometry = item_wrapper.array_mesh
	if not geometry:
		printerr("AWOCAvatar: Wrapper has no array_mesh assigned.") 
		return
	var new_instance = MeshInstance3D.new()
	new_instance.name = mesh_name
	new_instance.mesh = geometry
	active_skeleton.add_child(new_instance)
	new_instance.skeleton = new_instance.get_path_to(active_skeleton)
	equipped_meshes[mesh_name] = new_instance


func _unequip_mesh(mesh_name: String) -> void:
	if equipped_meshes.has(mesh_name):
		var instance = equipped_meshes[mesh_name]
		if is_instance_valid(instance):
			instance.queue_free()
		equipped_meshes.erase(mesh_name)
