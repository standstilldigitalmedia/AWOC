@tool
class_name AWOCMaterial extends AWOCResourceBase

@export var image_dictionary: Dictionary
@export var overlays_dictionary: Dictionary

func get_albedo_image() -> Image:
	if image_dictionary.has("albedo") and image_dictionary["albedo"].resource_uid > 0:
		var albedo_image = AWOCImage.load_image(ResourceUID.get_id_path(image_dictionary["albedo"].resource_uid))
		albedo_image.convert(Image.FORMAT_RGBA8)
		return albedo_image
	return null
	
func get_orm_image() -> Image:
	if image_dictionary.has("orm") and image_dictionary["orm"].resource_uid > 0:
		return AWOCImage.load_image(ResourceUID.get_id_path(image_dictionary["orm"].resource_uid))
	return null
	
func get_occlusion_image() -> Image:
	if image_dictionary.has("occlusion") and image_dictionary["occlusion"].resource_uid > 0:
		return AWOCImage.load_image(ResourceUID.get_id_path(image_dictionary["occlusion"].resource_uid))
	return null
	
func get_roughness_image() -> Image:
	if image_dictionary.has("roughness") and image_dictionary["roughness"].resource_uid > 0:
		return AWOCImage.load_image(ResourceUID.get_id_path(image_dictionary["roughness"].resource_uid))
	return null
	
func get_metallic_image() -> Image:
	if image_dictionary.has("metallic") and image_dictionary["metallic"].resource_uid > 0:
		return AWOCImage.load_image(ResourceUID.get_id_path(image_dictionary["metallic"].resource_uid))
	return null
	
func get_albedo_with_overlays(color_dictionary: Dictionary) -> Image:
	var albedo_image: Image = get_albedo_image()
	for overlay in overlays_dictionary:
		albedo_image = overlays_dictionary[overlay].combine_albedo_with_overlay(color_dictionary, albedo_image)
	return albedo_image
	
