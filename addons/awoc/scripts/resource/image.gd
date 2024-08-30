@tool
class_name AWOCImage extends AWOCResourceBase

var image: Image

func load_image(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print(str("Could not load image at: ",path))
		return
	var buffer = file.get_buffer(file.get_length())
	image = Image.new()
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
	
func l8_to_la8() -> Image:
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),1):
		if src_img_bytes[a] > 0:
			dest_image_bytes[dest_image_counter] = src_img_bytes[a]
			dest_image_bytes[dest_image_counter + 1] = 255
		dest_image_counter += 2
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func rgb8_to_la8() -> Image:
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),3):
		if src_img_bytes[a] > 0:
			dest_image_bytes[dest_image_counter] = (src_img_bytes[a] + src_img_bytes[a + 1] + src_img_bytes[a + 2]) / 3
			dest_image_bytes[dest_image_counter + 1] = 255
		dest_image_counter += 2
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func rgba8_to_la8() -> Image:
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),4):
		if src_img_bytes[a] > 0:
			dest_image_bytes[dest_image_counter] = (src_img_bytes[a] + src_img_bytes[a + 1] + src_img_bytes[a + 2]) / 3
			dest_image_bytes[dest_image_counter + 1] = src_img_bytes[a + 3]
		dest_image_counter += 2
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func l8_to_rgba8() -> Image:
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),1):
		if src_img_bytes[a] > 0:
			dest_image_bytes[dest_image_counter] = src_img_bytes[a]
			dest_image_bytes[dest_image_counter + 1] = src_img_bytes[a]
			dest_image_bytes[dest_image_counter + 2] = src_img_bytes[a]
			dest_image_bytes[dest_image_counter + 3] = 255
		dest_image_counter += 4
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func la8_to_rgba8() -> Image:
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),2):
		dest_image_bytes[dest_image_counter] = src_img_bytes[a]
		dest_image_bytes[dest_image_counter + 1] = src_img_bytes[a]
		dest_image_bytes[dest_image_counter + 2] = src_img_bytes[a]
		dest_image_bytes[dest_image_counter + 3] = src_img_bytes[a + 1]
		dest_image_counter += 4
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func rgb8_to_rgba8():
	var dest_image: Image = Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RGBA8)
	var dest_image_bytes = dest_image.get_data()
	var src_img_bytes = image.get_data()
	var dest_image_counter: int = 0
	for a in range(0,src_img_bytes.size(),3):
		dest_image_bytes[dest_image_counter] = src_img_bytes[a]
		dest_image_bytes[dest_image_counter + 1] = src_img_bytes[a + 1]
		dest_image_bytes[dest_image_counter + 2] = src_img_bytes[a + 2]
		dest_image_bytes[dest_image_counter + 3] = 255
		dest_image_counter += 4
	dest_image.set_data(dest_image.get_width(), dest_image.get_height(),false,Image.FORMAT_RGBA8,dest_image_bytes)
	return dest_image
	
func load_and_format_rgba8_image(path: String):
	load_image(path)
	match image.get_format():
		Image.FORMAT_L8:
			l8_to_rgba8()
		Image.FORMAT_LA8:
			la8_to_rgba8()
		Image.FORMAT_RGB8:
			rgb8_to_rgba8()
		Image.FORMAT_RGBA8:
			pass
		_:
			printerr("AWOC does not support the given image format.")
	
func load_and_format_l8_image(path: String):
	pass
	"""load_image(path)
	match image.get_format():
		Image.FORMAT_L8:
			pass
		Image.FORMAT_LA8:
			#la8_to_l8()
		Image.FORMAT_RGB8:
			#rgb8_to_l8()
		Image.FORMAT_RGBA8:
			#rgba8_to_l8()
		_:
			image.convert(Image.Format.FORMAT_L8)"""
