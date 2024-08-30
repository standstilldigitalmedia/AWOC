@tool
class_name AWOCResourceController extends AWOCResourceControllerBase

var awoc_resource: AWOC
var awoc_uid: int

func save_awoc():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_uid))
	scan()
	awoc_resource.emit_changed()
	
func add_new_slot(slot_name: String, hide_slots_array: Array):
	var new_slot_resource: AWOCSlot = AWOCSlot.new()
	new_slot_resource.hide_slots_array = hide_slots_array
	add_resource_to_dictionary(slot_name, awoc_resource.slots_dictionary, new_slot_resource)
	save_awoc()
	
func remove_slot(slot_name: String):
	for slot in awoc_resource.slots_dictionary:
		var hide_slot_array: Array = awoc_resource.slots_dictionary[slot].hide_slots_array
		for a in hide_slot_array.size():
			if hide_slot_array[a] == slot_name:
				hide_slot_array.remove_at(a)
				break		
	remove_resource_from_dictionary(awoc_resource.slots_dictionary, slot_name)
	save_awoc()
	
func rename_slot(old_name: String, new_name: String):
	for slot in awoc_resource.slots_dictionary:
		var hide_slot_array: Array = awoc_resource.slots_dictionary[slot].hide_slots_array
		for a in hide_slot_array.size():
			if hide_slot_array[a] == old_name:
				hide_slot_array[a] = new_name
				break		
	rename_resource_in_dictionary(old_name, new_name, awoc_resource.slots_dictionary)
	save_awoc()
	
func add_new_hide_slot(slot_name: String, hide_slot_name: String):
	awoc_resource.slots_dictionary[slot_name].hide_slot_array.append(hide_slot_name)
	save_awoc()
	
func remove_hide_slot(slot_name: String, hide_slot_name: String):
	var hide_slot_array: Array = awoc_resource.slots_dictionary[slot_name].hide_slots_array
	for a in hide_slot_array.size():
		if hide_slot_array[a] == hide_slot_name:
			hide_slot_array.remove_at(a)
			break
	save_awoc()
	
func create_avatar(avatar_path: String):
	var avatar_scene = load(avatar_path)
	var avatar = avatar_scene.instantiate()
	var skeleton_resource: AWOCSkeleton = AWOCSkeleton.new()
	var skeleton: Skeleton3D = skeleton_resource.recursive_get_skeleton(avatar)
	var base_path: String = ResourceUID.get_id_path(awoc_uid).get_base_dir()
	var skeleton_path = base_path + "/skeleton"
	var mesh_path = base_path + "/meshes"
	skeleton_resource.serialize_skeleton(skeleton)
	var skeleton_reference = AWOCResourceReference.new()
	skeleton_reference.resource_uid = create_resource_on_disk(skeleton_resource,"skeleton", skeleton_path)
	awoc_resource.skeleton_resource_reference = skeleton_reference
	for mesh in skeleton.get_children():
		if mesh is MeshInstance3D:
			var mesh_resource: AWOCMesh = AWOCMesh.new()
			mesh_resource.serialize_mesh(mesh)
			create_disk_resource(mesh_resource, mesh.name, mesh_path, awoc_resource.meshes_dictionary)
	save_awoc()
	
func remove_mesh(mesh_name: String):
	remove_disk_resource(mesh_name, awoc_resource.meshes_dictionary[mesh_name].resource_uid, awoc_resource.meshes_dictionary)
	if awoc_resource.meshes_dictionary.size() < 1:
		remove_resource_from_disk(awoc_resource.skeleton_resource_reference.resource_uid)
		awoc_resource.skeleton_uid = 0
	save_awoc()
	
func rename_mesh(old_name: String, new_name: String):
	rename_disk_resource(old_name, new_name,awoc_resource.meshes_dictionary[old_name].resource_uid,awoc_resource.meshes_dictionary)
	save_awoc()
	
func instatiate_avatar_from_mesh_list(mesh_name_list: Array) -> Node3D:
	if awoc_resource.skeleton_resource_reference.resource_uid < 1:
		push_error("AWOC must have a skeleton.")
		return null
	if awoc_resource.meshes_dictionary.size() < mesh_name_list.size():
		push_error("You are trying to instantiate more meshes than this AWOC has available.")
		return null
	var avatar_node = Node3D.new()
	var skeleton_resource = load_resource("Skeleton", awoc_resource.skeleton_resource_reference.resource_uid)
	var skeleton: Skeleton3D = skeleton_resource.deserialize_skeleton()
	if skeleton == null:
		push_error("There was a problem serializing the AWOC skeleton.")
		return null
	for name in mesh_name_list:
		var mesh_resource = load_resource(name, awoc_resource.meshes_dictionary[name].resource_uid)
		mesh_resource.deserialize_mesh(skeleton)
	avatar_node.add_child(skeleton)
	return avatar_node
	
func add_new_color(color_name: String, color: Color):
	if awoc_resource.colors_dictionary.has(color_name):
		printerr("Color " + color_name + " already exists.")
		return
	awoc_resource.colors_dictionary[color_name] = color
	save_awoc()
	
func remove_color(color_name: String):
	if !awoc_resource.colors_dictionary.has(color_name):
		printerr("Color " + color_name + " does not exist.")
		return
	awoc_resource.colors_dictionary.erase(color_name)
	save_awoc()
	
func rename_color(old_name: String, new_name: String):
	rename_resource_in_dictionary(old_name, new_name, awoc_resource.colors_dictionary)
	save_awoc()
	
func change_color(color_name: String, color: Color):
	if !awoc_resource.colors_dictionary.has(color_name):
		printerr("Color " + color_name + " does not exist.")
		return
	awoc_resource.colors_dictionary[color_name] = color
	save_awoc()
	
func add_new_material(material_name: String, material: AWOCMaterial):
	var path: String = ResourceUID.get_id_path(awoc_uid).get_base_dir() + "/materials"
	create_disk_resource(material,material_name,path, awoc_resource.materials_dictionary)
	save_awoc()
	
func remove_material(material_name: String):
	remove_disk_resource(material_name, awoc_resource.materials_dictionary[material_name].resource_uid, awoc_resource.materials_dictionary)
	save_awoc()
	
func rename_material(old_name: String, new_name: String):
	rename_disk_resource(old_name, new_name, awoc_resource.materials_dictionary[old_name].resource_uid, awoc_resource.materials_dictionary)
	save_awoc()
	
func apply_settings(orm: bool, occlusion: bool, roughness: bool, metallic: bool):
	if awoc_resource.material_settings_array == null or awoc_resource.material_settings_array.size() < 1:
		awoc_resource.material_settings_array = Array()
		awoc_resource.material_settings_array.append(true)
		awoc_resource.material_settings_array.append(orm)
		awoc_resource.material_settings_array.append(occlusion)
		awoc_resource.material_settings_array.append(roughness)
		awoc_resource.material_settings_array.append(metallic)
	else:
		awoc_resource.material_settings_array[AWOCNewMaterialControl.ALBEDO] = true
		awoc_resource.material_settings_array[AWOCNewMaterialControl.ORM] = orm
		awoc_resource.material_settings_array[AWOCNewMaterialControl.OCCLUSION] = occlusion
		awoc_resource.material_settings_array[AWOCNewMaterialControl.ROUGHNESS] = roughness
		awoc_resource.material_settings_array[AWOCNewMaterialControl.METALLIC] = metallic
	save_awoc()
	
func get_material_settings() -> Array:
	if awoc_resource.material_settings_array == null or awoc_resource.material_settings_array.size() < 1:
		awoc_resource.material_settings_array = Array()
		awoc_resource.material_settings_array.append(false)
		awoc_resource.material_settings_array.append(false)
		awoc_resource.material_settings_array.append(false)
		awoc_resource.material_settings_array.append(false)
		awoc_resource.material_settings_array.append(false)
		save_awoc()
	return awoc_resource.material_settings_array
	
func get_slots_dictionary() -> Dictionary:
	return awoc_resource.slots_dictionary
	
func get_meshes_dictionary() -> Dictionary:
	return awoc_resource.meshes_dictionary
	
func get_colors_dictionary() -> Dictionary:
	return awoc_resource.colors_dictionary
	
func get_materials_dictionary() -> Dictionary:
	return awoc_resource.materials_dictionary

func _init(a_resource: AWOC, a_uid: int):
	awoc_resource = a_resource
	awoc_uid = a_uid
