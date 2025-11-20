@tool
class_name AWOCValidator
extends RefCounted

const NAME_MIN_CHAR: int = 4
const NAME_MAX_CHAR: int = 50
const VALID_IMAGE_EXTENSIONS: Array[String] = ["bmp", "jpg", "jpeg", "png", "tga", "webp"]
const VALID_AVATAR_EXTENSIONS: Array[String] = ["glb"]


static func is_valid_directory_path(path: String) -> bool:
	if path.is_empty():
		return false
	return DirAccess.dir_exists_absolute(path)
	
	
static func is_valid_parent_path(file_path: String) -> bool:
	if file_path.is_empty():
		return false
	var parent_dir  = file_path.get_base_dir()
	return !parent_dir.is_empty() and DirAccess.dir_exists_absolute(parent_dir)


static func is_avatar_file(path: String) -> bool:
	if !FileAccess.file_exists(path):
		return false
	return path.get_extension().to_lower() in VALID_AVATAR_EXTENSIONS


static func is_image_file(path: String) -> bool:
	if !FileAccess.file_exists(path):
		return false
	return path.get_extension().to_lower() in VALID_IMAGE_EXTENSIONS


static func is_valid_name(name: String) -> bool:
	var length = name.length()
	if length < NAME_MIN_CHAR or length > NAME_MAX_CHAR:
		return false
	if not name.is_valid_filename():
		return false
	return true
