@tool
class_name AWOC extends AWOCResourceBase

@export var awoc_name: String
@export var slots_dictionary: Dictionary
@export var skeleton_resource_reference: AWOCResourceReference
@export var meshes_dictionary: Dictionary
@export var colors_dictionary: Dictionary
@export var materials_dictionary: Dictionary
@export var material_settings_array: Array

func get_slot_by_name(name: String) -> AWOCSlot:
	return AWOCResourceControllerBase.load_resource(name, slots_dictionary[name].resource_uid)
	
func get_skeleton() -> AWOCSkeleton:
	return AWOCResourceControllerBase.load_resource("Skeleton", skeleton_resource_reference.resource_uid)
	
func get_mesh_by_name(name: String) -> AWOCMesh:
	return AWOCResourceControllerBase.load_resource(name, meshes_dictionary[name])
	
func get_color_by_name(name: String) -> Color:
	return colors_dictionary[name]
	
func get_material_by_name(name: String) -> AWOCMaterial:
	return AWOCResourceControllerBase.load_resource(name, materials_dictionary[name].resource_uid)
	
func get_material_settings() -> Array:
	if material_settings_array == null or material_settings_array.size() < 1:
		material_settings_array = Array()
		material_settings_array.append(false)
		material_settings_array.append(false)
		material_settings_array.append(false)
		material_settings_array.append(false)
		material_settings_array.append(false)
	return material_settings_array
	
func get_slots_dictionary() -> Dictionary:
	return slots_dictionary
	
func get_meshes_dictionary() -> Dictionary:
	return meshes_dictionary
	
func get_colors_dictionary() -> Dictionary:
	return colors_dictionary
	
func get_materials_dictionary() -> Dictionary:
	return materials_dictionary
