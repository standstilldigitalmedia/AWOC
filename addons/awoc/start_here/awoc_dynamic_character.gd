@tool
class_name AWOCDynamicCharacter extends Node3D

@export var texture_rect: TextureRect
var awoc_resource: AWOC
var mesh_dictionary: Dictionary
var recipe_dictionary: Dictionary
var skeleton: Skeleton3D
var albedo_image: Image
var orm_image: Image
var occlusion_image: Image
var roughness_image: Image
var metallic_image: Image
var character_material: BaseMaterial3D

func equip_recipe(recipe_name):
	var recipe_resource: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	var slot_name: String = recipe_resource.slot_name
	var slot_index: int = awoc_resource.get_slot_index_by_name(slot_name)
	var material_resource: AWOCMaterial = load(ResourceUID.get_id_path(recipe_resource.material_resource_reference.resource_uid))
	var mesh_resource: AWOCMesh = load(ResourceUID.get_id_path(recipe_resource.mesh_resource_reference.resource_uid))
	var mesh: MeshInstance3D = mesh_resource.deserialize_mesh(skeleton)
	mesh_dictionary[slot_name] = mesh
	recipe_dictionary[slot_name] = recipe_resource
	albedo_image.blit_rect(material_resource.get_albedo_with_overlays(awoc_resource.colors_dictionary),Rect2i(awoc_resource.image_width * slot_index, 0, awoc_resource.image_width, awoc_resource.image_height),Vector2i(0, 0))
	character_material.albedo_texture = ImageTexture.create_from_image(albedo_image)
	mesh.material_override = character_material
	
func unequip_recipe(recipe_name):
	var recipe: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)

func get_base_image(format: Image.Format) -> Image:
	var return_image = Image.new()
	return_image = return_image.create_empty(awoc_resource.image_width,awoc_resource.image_height,false,format)
	return_image.fill(Color(0,0,0,1))
	return return_image
	
func init_material():
	if awoc_resource.material_settings_dictionary.has("orm") and awoc_resource.material_settings_dictionary["orm"] == true:
		character_material = ORMMaterial3D.new()
		character_material.orm_texture = ImageTexture.create_from_image(orm_image)
	else:
		character_material = StandardMaterial3D.new()
	character_material.albedo_texture = ImageTexture.create_from_image(albedo_image)
	if awoc_resource.material_settings_dictionary.has("occlusion") and awoc_resource.material_settings_dictionary["occlusion"] == true:
		character_material.ao_texture = ImageTexture.create_from_image(occlusion_image)
	if awoc_resource.material_settings_dictionary.has("metallic") and awoc_resource.material_settings_dictionary["metallic"] == true:
		character_material.metallic_texture = ImageTexture.create_from_image(metallic_image)
	if awoc_resource.material_settings_dictionary.has("roughness") and awoc_resource.material_settings_dictionary["roughness"] == true:
		character_material.roughness_texture = ImageTexture.create_from_image(roughness_image)
	
func init_material_images():
	albedo_image = get_base_image(Image.FORMAT_RGBA8)
	orm_image = get_base_image(Image.FORMAT_RGBA8)
	occlusion_image = get_base_image(Image.FORMAT_RGBA8)
	roughness_image = get_base_image(Image.FORMAT_RGBA8)
	metallic_image = get_base_image(Image.FORMAT_RGBA8)

func deserialize_skeleton():
	skeleton = awoc_resource.get_skeleton()
	add_child(skeleton)

func add_mesh_to_list(mesh_name: String):
	mesh_dictionary[mesh_name] = awoc_resource.get_mesh_by_name(mesh_name).deserialize_mesh(skeleton)

func remove_mesh_from_list(mesh_name: String):
	mesh_dictionary[mesh_name].queue_free()
	mesh_dictionary.erase(mesh_name)
	
func reset_meshes():
	for mesh_name in mesh_dictionary:
		mesh_dictionary[mesh_name].queue_free()
	mesh_dictionary = {}
	
func init_dynamic_character(awoc: AWOC):
	init_base_dynamic_character(awoc)
	init_material_images()
	init_material()
	
func init_base_dynamic_character(awoc: AWOC):
	awoc_resource = awoc
	mesh_dictionary = {}
	deserialize_skeleton()

"""func create_material_albedo():
	var first_material: AWOCMaterial = load(ResourceUID.get_id_path(awoc_resource.get_recipe_by_name("new recipe").material_resource_reference.resource_uid))
	texture_rect.texture = ImageTexture.create_from_image(first_material.get_albedo_with_overlays(awoc_resource.colors_dictionary))
	return 

func load_list_of_recipe_resources(recipe_name_list: Array) -> Array:
	var return_array: Array = Array()
	for recipe in recipe_name_list:
		if awoc_resource.get_recipes_dictionary().has(recipe):
			return_array.append(load(ResourceUID.get_id_path(awoc_resource.get_recipes_dictionary()[recipe].resource_uid)))
	return return_array
	
func get_used_slots_array(recipe_resource_list: Array[AWOCRecipe]) -> Array:
	var return_array: Array = Array()
	for recipe in recipe_resource_list:
		return_array.append(recipe.slot_name)
		for recipe_name in return_array:
			if recipe_name == recipe.slot_name:
				printerr("You can not equip 2 recipes ")
	return return_array

func instantiate_avatar_from_recipe_list(recipe_name_list: Array):
	var recipe_resource_list: Array = load_list_of_recipe_resources(recipe_name_list)
	if recipe_list_array.size() < 1:
		return
	var skeleton: Skeleton3D = awoc_resource.get_skeleton().deserialize_skeleton()
	if skeleton == null:
		return
	
	add_child(skeleton)
	var slot_offset_dictionary = {}
	var offset = 0
	var max_offset = awoc_resource.slots_dictionary.size()
	for slot in awoc_resource.slots_dictionary:
		slot_offset_dictionary[slot] = offset
		offset += 1
	var used_slots_array: Array = Array()
	for recipe in recipe_name_list:
		var recipe_resource: AWOCRecipe = load(ResourceUID.get_id_path(awoc_resource.get_recipes_dictionary()[recipe].resource_uid))
		for used_slot in used_slots_array:
			if used_slot == recipe_resource.slot_name:
				printerr("Can not have two recipes with the same slot equipped")
				return
		used_slots_array.append(recipe_resource.slot_name)"""
