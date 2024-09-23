@tool
class_name AWOCImage extends AWOCResourceBase

static func load_image(path: String) -> Image:
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print(str("Could not load image at: ",path))
		return
	var buffer = file.get_buffer(file.get_length())
	var image: Image = Image.new()
	var file_name = path.get_file()
	var split = file_name.split(".")
	var error
	match split[1]:
		"bmp":
			error = image.load_bmp_from_buffer(buffer)
		"jpg":
			error = image.load_jpg_from_buffer(buffer)
		"png":
			error = image.load_png_from_buffer(buffer)
		"tga":
			error = image.load_tga_from_buffer(buffer)
	if error != OK:
		print(str("Could not load image at: " + path + " with error: " + error))
		return
	return image
