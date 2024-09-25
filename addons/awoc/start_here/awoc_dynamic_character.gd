@tool
class_name AWOCDynamicCharacter extends CanvasLayer

@export var awoc_resource: AWOC
@export var texture_rect: TextureRect
var recipe_list_dictionary: Dictionary

func get_default_recipes():
	pass

func create_material_albedo():
	var first_material: AWOCMaterial = load(ResourceUID.get_id_path(awoc_resource.get_recipe_by_name("new recipe").material_resource_reference.resource_uid))
	texture_rect.texture = ImageTexture.create_from_image(first_material.get_albedo_with_overlays(awoc_resource.colors_dictionary))
	return 

func unequip_recipe(recipe_name):
	var recipe_resource: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	"""for slot in recipe_list_dictionary:
		if recipe_list_dictionary[slot] == recipe_resource:
			recipe_list_dictionary.erase(slot)
			if default_recipe_list.has(slot) and default_recipe_list[slot] != recipe_list_dictionary[slot]:
				recipe_list_dictionary[slot] = default_recipe_list[slot]
			break"""
			
func equip_recipe(recipe_name):
	var recipe: AWOCRecipe = awoc_resource.get_recipe_by_name(recipe_name)
	if recipe_list_dictionary.has(recipe.slot_name):
		recipe_list_dictionary.erase(recipe.slot_name)
	recipe_list_dictionary[recipe.slot_name] = recipe

func _ready():
	create_material_albedo()

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
	"""if recipe_list_array.size() < 1:
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
