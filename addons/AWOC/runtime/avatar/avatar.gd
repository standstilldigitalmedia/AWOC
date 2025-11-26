@tool
class_name AWOCAvatar
extends Node3D

# The specific AWOC definition this avatar is using
var awoc_resource: AWOCResource

# Internal State
var active_skeleton: Skeleton3D = null
var equipped_meshes: Dictionary = {}  # Key: String (Mesh Name), Value: MeshInstance3D


# Call this first to build the base rig
func initialize_avatar(resource: AWOCResource) -> void:
	# 1. Cleanup existing if we are re-initializing
	if active_skeleton:
		active_skeleton.queue_free()
		active_skeleton = null

	for mesh in equipped_meshes.values():
		if is_instance_valid(mesh):
			mesh.queue_free()
	equipped_meshes.clear()

	awoc_resource = resource

	# 2. Load the Skeleton from the Resource Reference
	if not awoc_resource.skeleton_reference:
		printerr("AWOCAvatar: No skeleton reference found in resource.")
		return

	# Debug output
	print("DEBUG: skeleton_reference exists")
	print("DEBUG: skeleton_reference UID: ", awoc_resource.skeleton_reference.get_uid())
	print("DEBUG: skeleton_reference get_path(): ", awoc_resource.skeleton_reference.get_path())
	print("DEBUG: skeleton_reference.path: ", awoc_resource.skeleton_reference.path)

	var loaded_resource = awoc_resource.skeleton_reference.load_resource()
	print("DEBUG: loaded_resource type: ", type_string(typeof(loaded_resource)))
	print("DEBUG: loaded_resource: ", loaded_resource)

	if loaded_resource:
		print("DEBUG: loaded_resource class: ", loaded_resource.get_class())

	var skel_scene = loaded_resource as PackedScene
	if not skel_scene:
		printerr("AWOCAvatar: Failed to load skeleton scene.")
		printerr("DEBUG: Resource loaded but is not a PackedScene")
		return

	# 3. Instantiate and Parent
	active_skeleton = skel_scene.instantiate() as Skeleton3D
	if not active_skeleton:
		printerr("AWOCAvatar: PackedScene instantiated but is not a Skeleton3D")
		return

	print("DEBUG: Skeleton successfully instantiated: ", active_skeleton.name)
	add_child(active_skeleton)

	# Ensure it is centered
	active_skeleton.position = Vector3.ZERO
	active_skeleton.rotation = Vector3.ZERO


# The Main Public API
func toggle_mesh(mesh_name: String, show: bool) -> void:
	if show:
		_equip_mesh(mesh_name)
	else:
		_unequip_mesh(mesh_name)


# Internal Logic
func _equip_mesh(mesh_name: String) -> void:
	# Safety Checks
	if not active_skeleton:
		printerr("AWOCAvatar: Cannot equip mesh, no skeleton initialized.")
		return
	if equipped_meshes.has(mesh_name):
		return  # Already equipped
	if not awoc_resource.mesh_dictionary.has(mesh_name):
		printerr("AWOCAvatar: Mesh not found in dictionary: " + mesh_name)
		return

	# 1. Get the Wrapper Resource
	var mesh_ref = awoc_resource.mesh_dictionary[mesh_name]
	var item_wrapper = mesh_ref

	# If using your Reference class:
	if mesh_ref is AWOCResourceReference:
		item_wrapper = mesh_ref.load_resource()

	if not item_wrapper or not item_wrapper is AWOCMeshResource:
		printerr("AWOCAvatar: Failed to load AWOCMeshResource for " + mesh_name)
		return

	# 2. Get the Actual Geometry
	var geometry = item_wrapper.array_mesh  # ← Fixed!
	if not geometry:
		printerr("AWOCAvatar: Wrapper has no array_mesh assigned.")  # ← Fixed!
		return

	# 3. Build the Node
	var new_instance = MeshInstance3D.new()
	new_instance.name = mesh_name
	new_instance.mesh = geometry

	# 4. The Magic Glue (Parenting & Skinning)
	active_skeleton.add_child(new_instance)
	new_instance.skeleton = new_instance.get_path_to(active_skeleton)

	# 5. Track it
	equipped_meshes[mesh_name] = new_instance


func _unequip_mesh(mesh_name: String) -> void:
	if equipped_meshes.has(mesh_name):
		var instance = equipped_meshes[mesh_name]
		if is_instance_valid(instance):
			instance.queue_free()
		equipped_meshes.erase(mesh_name)
