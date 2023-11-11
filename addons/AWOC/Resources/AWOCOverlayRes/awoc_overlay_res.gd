@tool
class_name AWOCOverlayRes extends Resource

@export var overlay_name: String
@export var overlay_image_array: Array
@export var overlay_type: AWOCEnums.MatType
@export var overlay_strength: float

func init_pixel_array(texture: Texture2D):
	overlay_image_array = []
	var texture_image: Image = texture.get_image()
	var texture_width: int = texture.get_width()
	var texture_height: int = texture.get_height()
	for a in texture_width:
		overlay_image_array.append([])
		for b in texture_height:
			var red_value: float = texture_image.get_pixel(a,b).r
			if red_value > 0:
				overlay_image_array[a].append(red_value)
			else:
				overlay_image_array[a].append(null)
			
func apply_color_to_texture(source_texture: Texture2D, color: Color):
	var array_width: int = overlay_image_array.size()
	var array_height: int = overlay_image_array[0].size()
	var source_image: Image = source_texture.get_image()
	for a in array_width:
		for b in array_height:
			if overlay_image_array[a][b] > 0:
				var source_color: Color = source_texture.get_pixel(a,b)
				source_image.set_pixel(a, b, source_color * color)
