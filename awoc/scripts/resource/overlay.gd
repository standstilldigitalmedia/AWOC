@tool
class_name AWOCOverlay extends AWOCResourceBase

@export var overlay_image_reference: AWOCResourceReference
@export var dynamic_color: Color
@export var shared_color: String
@export var overlay_strength: float
var image: Image

func create_overlay_image(color_dictionary: Dictionary):
	image = Image.new()
	var overlay_image = AWOCImage.load_image(ResourceUID.get_id_path(overlay_image_reference.resource_uid))
	image.convert(Image.FORMAT_RGBA8)
	overlay_image.convert(Image.FORMAT_RGBA8)
	var return_image_data = overlay_image.get_data()
	var overlay_image_data = overlay_image.get_data()
	var color: Color = Color(0,0,0,0)
	if dynamic_color != Color(0,0,0,0):
		color = dynamic_color
	elif shared_color != "":
		color = color_dictionary[shared_color]
	for a in range(0,overlay_image_data.size(),4):
		if overlay_image_data[a + 3] > 0:
			if color == Color(0,0,0,0):
				return_image_data[a] = int(overlay_image_data[a] * overlay_strength)
				return_image_data[a + 1] = int(overlay_image_data[a + 1] * overlay_strength)
				return_image_data[a + 2] = int(overlay_image_data[a + 2] * overlay_strength)
				return_image_data[a + 3] = int(overlay_strength * 255)
			else:
				return_image_data[a] = color.r * 255
				return_image_data[a + 1] = color.g * 255
				return_image_data[a + 2] = color.b * 255
				return_image_data[a + 3] = overlay_strength * 255
	image.set_data(overlay_image.get_width(), overlay_image.get_height(),false,Image.FORMAT_RGBA8,return_image_data)

func combine_albedo_with_overlay(color_dictionary: Dictionary, albedo_image: Image, invert: bool = false) -> Image:
	if image == null:
		create_overlay_image(color_dictionary)
	albedo_image.blend_rect(image,Rect2i(0,0,albedo_image.get_width(), albedo_image.get_height()),Vector2i(0,0))
	return albedo_image
