@tool
class_name AWOCResourceController extends AWOCResourceControllerBase

var awoc_resource: AWOC
var awoc_uid: int

func save_awoc():
	ResourceSaver.save(awoc_resource, ResourceUID.get_id_path(awoc_uid))
	awoc_resource.emit_changed()
	scan()
	
func add_new_slot(slot_name: String, hide_slots_array: Array[String]):
	var existing_slot: AWOCSlot = awoc_resource.get_slot_by_name(slot_name)
	if existing_slot != null:
		printerr("Slot " + slot_name + " already exists.")
		return
	var new_slot_resource: AWOCSlot = AWOCSlot.new()
	for a in hide_slots_array.size():
		new_slot_resource.hide_slots_array.append(hide_slots_array[a])
	new_slot_resource.slot_name = slot_name
	awoc_resource.slots_array.append(new_slot_resource)
	save_awoc()
	
func remove_slot(slot_name: String):
	var existing_slot: AWOCSlot = awoc_resource.get_slot_by_name(slot_name)
	if existing_slot == null:
		printerr("Slot " + slot_name + " does not exist.")
		return
	awoc_resource.slots_array.remove_at(awoc_resource.get_slot_index_by_name(slot_name))
	for slot in get_slots_array():
		for a in slot.hide_slots_array.size():
			if slot.hide_slots_array[a] == slot_name:
				slot.hide_slots_array.remove_at(a)
				printerr("Slot " + slot.slot_name + " will no longer hide slot " + slot.hide_slots_array[a] + ".")
				save_awoc()
				break
	for recipe in get_recipes_dictionary():
		var recipe_resource: AWOCRecipe = get_recipe_by_name(recipe)
		if recipe_resource.slot_name == slot_name:
			recipe_resource.slot_name = ""
			printerr("Recipe " + recipe + " is invalidated. Please assign a new slot to this recipe.")
			save_awoc()
			recipe_resource.emit_changed()
	
func rename_slot(old_name: String, new_name: String):
	var existing_slot: AWOCSlot = awoc_resource.get_slot_by_name(old_name)
	if existing_slot == null:
		printerr("Slot " + old_name + " does not exist.")
		return
	awoc_resource.get_slot_by_name(old_name).slot_name = new_name
	for slot in get_slots_array():
		for a in slot.hide_slots_array.size():
			if slot.hide_slots_array[a] == old_name:
				slot.hide_slots_array[a] = new_name
	for recipe in get_recipes_dictionary():
		var recipe_resource: AWOCRecipe = get_recipe_by_name(recipe)
		if recipe_resource.slot_name == old_name:
			recipe_resource.slot_name = new_name
			recipe_resource.emit_changed()
	save_awoc()
	
func add_new_hide_slot(slot_name: String, hide_slot_name: String):
	var existing_slot: AWOCSlot = awoc_resource.get_slot_by_name(slot_name)
	if existing_slot == null:
		printerr("Slot " + slot_name + " does not exist.")
		return
	awoc_resource.get_slot_by_name(slot_name).hide_slots_array.append(hide_slot_name)
	save_awoc()
	
func remove_hide_slot(slot_name: String, hide_slot_name: String):
	var existing_slot: AWOCSlot = awoc_resource.get_slot_by_name(slot_name)
	if existing_slot == null:
		printerr("Slot " + slot_name + " does not exist.")
		return
	existing_slot.hide_slots_array.erase(awoc_resource.get_hide_slot_index_by_name(slot_name, hide_slot_name))
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
	for awoc_recipe: AWOCRecipe in get_recipes_dictionary():
		if awoc_recipe.mesh_name == old_name:
			awoc_recipe.mesh_name = new_name
	rename_disk_resource(old_name, new_name,awoc_resource.meshes_dictionary[old_name].resource_uid,awoc_resource.meshes_dictionary)
	save_awoc()
	
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
	
func change_material_image(material_name: String, image_index: String, new_path: String):
	var material: AWOCMaterial = awoc_resource.get_material_by_name(material_name)
	material.image_dictionary[image_index].resource_uid = ResourceLoader.get_resource_uid(new_path)
	save_awoc()
	material.emit_changed()
	
func add_new_material(material_name: String, material: AWOCMaterial):
	add_resource_to_dictionary(material_name, get_materials_dictionary(),material)
	save_awoc()
	
func remove_material(material_name: String):
	remove_resource_from_dictionary(get_materials_dictionary(),material_name)
	save_awoc()
	
func rename_material(old_name: String, new_name: String):
	rename_resource_in_dictionary(old_name, new_name, get_materials_dictionary())
	for awoc_recipe: AWOCRecipe in get_recipes_dictionary():
		if awoc_recipe.material_name == old_name:
			awoc_recipe.material_name = new_name
	save_awoc()
	
func set_material_settings(albedo: bool, orm: bool, occlusion: bool, roughness: bool, metallic: bool):
	awoc_resource.material_settings_dictionary["albedo"] = albedo
	awoc_resource.material_settings_dictionary["orm"] = orm
	awoc_resource.material_settings_dictionary["occlusion"] = occlusion
	awoc_resource.material_settings_dictionary["roughness"] = roughness
	awoc_resource.material_settings_dictionary["metallic"] = metallic
	save_awoc()
	
func set_image_width_and_height(path: String):
	if awoc_resource.image_width < 1:
		var image: Image = AWOCImage.load_image(path)
		awoc_resource.image_width = image.get_width()
		awoc_resource.image_height = image.get_height()
		save_awoc()
	
func get_overlay_by_name(mat_name: String, overlay_name: String) -> AWOCOverlay:
	var material = get_material_by_name(mat_name)
	if material.overlays_dictionary.has(overlay_name):
		return material.overlays_dictionary[overlay_name]
	return null
	
func update_overlay(material_name: String, overlay_name: String, image_path: String, dynamic_color: Color, shared_color: String):
	var awoc_material: AWOCMaterial = get_material_by_name(material_name)
	var awoc_overlay: AWOCOverlay = awoc_material.overlays_dictionary[overlay_name]
	awoc_overlay.overlay_image_reference.resource_uid = ResourceLoader.get_resource_uid(image_path)
	awoc_overlay.dynamic_color = dynamic_color
	awoc_overlay.shared_color = shared_color
	save_awoc()
	awoc_material.emit_changed()
	
func update_overlay_strength(material_name: String, overlay_name: String, strength: float):
	var awoc_material: AWOCMaterial = get_material_by_name(material_name)
	var awoc_overlay: AWOCOverlay = awoc_material.overlays_dictionary[overlay_name]
	awoc_overlay.overlay_strength = strength
	save_awoc()
	awoc_material.emit_changed()
	
func add_new_overlay(overlay_name: String, material_name: String, overlay_resource: AWOCOverlay):
	var material: AWOCMaterial = awoc_resource.get_material_by_name(material_name)
	add_resource_to_dictionary(overlay_name, material.overlays_dictionary,overlay_resource)
	save_awoc()
	material.emit_changed()
	
func remove_overlay(material_name: String, overlay_name: String):
	var material: AWOCMaterial = get_material_by_name(material_name)
	remove_resource_from_dictionary(material.overlays_dictionary,overlay_name)
	save_awoc()
	material.emit_changed()	
	
func rename_overlay(material_name: String, overlay_name: String, new_name: String):
	printerr("mat name " + material_name + " overlay name " + overlay_name + " new_name " + new_name)
	var material: AWOCMaterial = get_material_by_name(material_name)
	rename_resource_in_dictionary(overlay_name, new_name,material.overlays_dictionary)
	save_awoc()
	material.emit_changed()	
	
func add_new_recipe(recipe_name: String, recipe: AWOCRecipe):
	add_resource_to_dictionary(recipe_name, get_recipes_dictionary(),recipe)
	save_awoc()
	
func remove_recipe(recipe_name: String):
	remove_resource_from_dictionary(get_recipes_dictionary(),recipe_name)
	save_awoc()
	
func rename_recipe(old_name: String, new_name: String):
	rename_resource_in_dictionary(old_name, new_name, get_recipes_dictionary())
	save_awoc()
	
func get_default_recipe_array() -> Array[String]:
	return awoc_resource.get_default_recipe_array()
	
func make_recipe_default(new_recipe_name: String):
	var default_recipe_array: Array[String] = get_default_recipe_array()
	var new_recipe_resource: AWOCRecipe = get_recipe_by_name(new_recipe_name)
	for array_recipe_name in default_recipe_array:
		var array_recipe_resource: AWOCRecipe = get_recipe_by_name(array_recipe_name)
		if new_recipe_resource.slot_name == array_recipe_resource.slot_name:
			array_recipe_resource.default = false
			save_awoc()
			array_recipe_resource.emit_changed()
			break
	new_recipe_resource.default = true
	save_awoc()
	new_recipe_resource.emit_changed()
	
func remove_recipe_default(recipe_name: String):
	var recipe_resource: AWOCRecipe = get_recipe_by_name(recipe_name)
	recipe_resource.default = false
	save_awoc()
	recipe_resource.emit_changed()
	
func get_slots_array() -> Array[AWOCSlot]:
	return awoc_resource.get_slots_array()
	
func get_slot_by_name(slot_name: String) -> AWOCSlot:
	return awoc_resource.get_slot_by_name(slot_name)
	
func get_slot_index_by_name(name: String) -> int:
	return awoc_resource.get_slot_index_by_name(name)
	
func get_slot_array_size() -> int:
	return awoc_resource.slots_array.size()
	
func get_meshes_dictionary() -> Dictionary:
	return awoc_resource.get_meshes_dictionary()
	
func get_mesh_by_name(name: String) -> AWOCMesh:
	return awoc_resource.get_mesh_by_name(name)
	
func get_colors_dictionary() -> Dictionary:
	return awoc_resource.get_colors_dictionary()
	
func get_materials_dictionary() -> Dictionary:
	return awoc_resource.get_materials_dictionary()
	
func get_material_by_name(mat_name: String):
	return awoc_resource.get_material_by_name(mat_name)
	
func get_material_settings() -> Dictionary:
	return awoc_resource.material_settings_dictionary
	
func get_recipes_dictionary() -> Dictionary:
	return awoc_resource.recipes_dictionary
	
func get_recipe_by_name(recipe_name: String):
	return awoc_resource.get_recipe_by_name(recipe_name)

func _init(a_resource: AWOC, a_uid: int):
	awoc_resource = a_resource
	awoc_uid = a_uid
