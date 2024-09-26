@tool
class_name AWOC extends AWOCResourceBase

@export var awoc_name: String
@export var slots_array: Array[AWOCSlot]
@export var skeleton_resource_reference: AWOCResourceReference
@export var meshes_dictionary: Dictionary
@export var colors_dictionary: Dictionary
@export var materials_dictionary: Dictionary
@export var material_settings_dictionary: Dictionary
@export var image_width: int
@export var image_height: int
@export var recipes_dictionary: Dictionary

func get_slot_index_by_name(name: String) -> int:
	for a in slots_array.size():
		if slots_array[a].slot_name == name:
			return a
	return -1
	
func get_slot_by_name(name: String) -> AWOCSlot:
	var slot_index: int = get_slot_index_by_name(name)
	if slot_index == -1:
		return null
	return slots_array[slot_index]
	
func get_hide_slot_index_by_name(slot_name: String, hide_slot_name: String):
	var slot: AWOCSlot = get_slot_by_name(slot_name)
	if slot == null:
		assert("Slot " + slot_name + " does not exist")
	for a in slot.hide_slots_array.size():
		if slot.hide_slots_array[a] == slot_name:
			return a
	return -1
	
func get_skeleton() -> Skeleton3D:
	if skeleton_resource_reference == null:
		return null
	return AWOCResourceControllerBase.load_resource("Skeleton", skeleton_resource_reference.resource_uid).deserialize_skeleton()
	
func get_skeleton_resource() -> AWOCSkeleton:
	return AWOCResourceControllerBase.load_resource("Skeleton", skeleton_resource_reference.resource_uid)
	
func get_mesh_by_name(name: String) -> AWOCMesh:
	return AWOCResourceControllerBase.load_resource(name, meshes_dictionary[name].resource_uid)
	
func get_color_by_name(name: String) -> Color:
	return colors_dictionary[name]
	
func get_material_by_name(mat_name: String) -> AWOCMaterial:
	if materials_dictionary.has(mat_name):
		if ResourceUID.has_id(materials_dictionary[mat_name].resource_uid):
			return AWOCResourceControllerBase.load_resource(mat_name, materials_dictionary[mat_name].resource_uid)
		else:
			return load(materials_dictionary[mat_name].path)
	return null
	
func get_recipe_by_name(recipe_name: String) -> AWOCRecipe:
	if recipes_dictionary.has(recipe_name):
		if ResourceUID.has_id(recipes_dictionary[recipe_name].resource_uid):
			return AWOCResourceControllerBase.load_resource(recipe_name, recipes_dictionary[recipe_name].resource_uid)
		else:
			return load(recipes_dictionary[recipe_name].path)
	return null
	
func get_slots_array() -> Array[AWOCSlot]:
	return slots_array
	
func get_meshes_dictionary() -> Dictionary:
	return meshes_dictionary
	
func get_colors_dictionary() -> Dictionary:
	return colors_dictionary
	
func get_materials_dictionary() -> Dictionary:
	return materials_dictionary
	
func get_recipes_dictionary() -> Dictionary:
	return recipes_dictionary
	
func get_default_recipe_array() -> Array[String]:
	var return_array: Array = []
	#return_array.resize(slots_array.size())
	for recipe in recipes_dictionary:
		var recipe_resource: AWOCRecipe = get_recipe_by_name(recipe)
		if recipe_resource.default == true:
			return_array.append(recipe)
	return return_array
	
