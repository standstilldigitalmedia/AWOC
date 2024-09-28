class_name AWOCDynamicCharacter extends Node3D

#@export var texture_rect: TextureRect
@export var awoc_resource: AWOC
var mesh_dictionary: Dictionary
var recipe_dictionary: Dictionary
var skeleton: Skeleton3D
var albedo_image: Image
var orm_image: Image
var occlusion_image: Image
var roughness_image: Image
var metallic_image: Image
var character_material: BaseMaterial3D

func update_dynamic_color(recipe_name: String, overlay_name: String, new_color: Color):
	var recipe: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	var material_resource: AWOCMaterial = awoc_resource.get_material_by_name(recipe.material_name)
	if material_resource.overlays_dictionary[overlay_name].dynamic_color != Color(0,0,0,0):
		material_resource.overlays_dictionary[overlay_name].dynamic_color = new_color
		material_resource.overlays_dictionary[overlay_name].create_overlay_image(awoc_resource.get_colors_dictionary())
		var slot_index: int = awoc_resource.get_slot_index_by_name(recipe.slot_name)
		albedo_image.blit_rect(material_resource.get_albedo_with_overlays(awoc_resource.colors_dictionary),Rect2i(0, 0, awoc_resource.image_width, awoc_resource.image_height),Vector2i(awoc_resource.image_width * slot_index, 0))
		character_material.albedo_texture = ImageTexture.create_from_image(albedo_image)
					
func update_shared_color(color_name: String, new_color: Color):
	if awoc_resource.get_colors_dictionary().has(color_name):
		awoc_resource.get_colors_dictionary()[color_name] = new_color
		awoc_resource.emit_changed()
		for recipe in recipe_dictionary:
			var material_resource: AWOCMaterial = awoc_resource.get_material_by_name(recipe_dictionary[recipe].material_name)
			for overlay in material_resource.overlays_dictionary:
				if material_resource.overlays_dictionary[overlay].shared_color == color_name:
					material_resource.overlays_dictionary[overlay].create_overlay_image(awoc_resource.get_colors_dictionary())
					var slot_index: int = awoc_resource.get_slot_index_by_name(recipe_dictionary[recipe].slot_name)
					albedo_image.blit_rect(material_resource.get_albedo_with_overlays(awoc_resource.colors_dictionary),Rect2i(0, 0, awoc_resource.image_width, awoc_resource.image_height),Vector2i(awoc_resource.image_width * slot_index, 0))
		character_material.albedo_texture = ImageTexture.create_from_image(albedo_image)
	
func equip_recipe(recipe_name):
	var recipe_resource: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	recipe_dictionary[recipe_name] = recipe_resource
	var slot_name: String = recipe_resource.slot_name
	var slot_index: int = awoc_resource.get_slot_index_by_name(slot_name)
	var material_resource: AWOCMaterial = awoc_resource.get_material_by_name(recipe_resource.material_name)
	var mesh_resource: AWOCMesh = awoc_resource.get_mesh_by_name(recipe_resource.mesh_name)
	mesh_resource.scale_and_offest_uvs_in_surface_array(awoc_resource.slots_array.size(), slot_index)
	var mesh: MeshInstance3D = mesh_resource.deserialize_mesh(skeleton)
	if mesh_dictionary.has(slot_name) and mesh_dictionary[slot_name] != null:
		mesh_dictionary[slot_name].queue_free()
	mesh_dictionary[slot_name] = mesh
	recipe_dictionary[slot_name] = recipe_resource
	albedo_image.blit_rect(material_resource.get_albedo_with_overlays(awoc_resource.colors_dictionary),Rect2i(0, 0, awoc_resource.image_width, awoc_resource.image_height),Vector2i(awoc_resource.image_width * slot_index, 0))
	character_material.albedo_texture = ImageTexture.create_from_image(albedo_image)
	mesh.material_override = character_material
	#texture_rect.texture = ImageTexture.create_from_image(albedo_image)
	
func unequip_recipe(recipe_name):
	var recipe: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	recipe_dictionary.erase(recipe_name)
	if mesh_dictionary.has(recipe.slot_name):
		mesh_dictionary[recipe.slot_name].queue_free()
		mesh_dictionary.erase(recipe.slot_name)

func get_base_image(format: Image.Format) -> Image:
	var return_image = Image.new()
	return_image = return_image.create_empty(awoc_resource.image_width * awoc_resource.slots_array.size(),awoc_resource.image_height,false,format)
	return_image.fill(Color(1,0,0,1))
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
	
"""func _ready():
	init_dynamic_character(awoc_resource)
	equip_recipe("frister")
	equip_recipe("second")"""
