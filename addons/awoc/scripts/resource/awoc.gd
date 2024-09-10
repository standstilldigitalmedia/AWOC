@tool
class_name AWOC extends AWOCResourceBase

@export var awoc_name: String
@export var slots_dictionary: Dictionary
@export var skeleton_resource_reference: AWOCResourceReference
@export var meshes_dictionary: Dictionary
@export var colors_dictionary: Dictionary
@export var materials_dictionary: Dictionary
@export var material_settings_dictionary: Dictionary

func get_slot_by_name(name: String) -> AWOCSlot:
	return AWOCResourceControllerBase.load_resource(name, slots_dictionary[name].resource_uid)
	
func get_skeleton() -> AWOCSkeleton:
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
	
func get_slots_dictionary() -> Dictionary:
	return slots_dictionary
	
func get_meshes_dictionary() -> Dictionary:
	return meshes_dictionary
	
func get_colors_dictionary() -> Dictionary:
	return colors_dictionary
	
func get_materials_dictionary() -> Dictionary:
	return materials_dictionary
