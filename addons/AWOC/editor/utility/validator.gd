@tool
class_name AWOCValidator
extends Node

const NAME_MIN_CHAR: int = 4
const NAME_MAX_CHAR: int = 50


static func is_valid_path(path: String) -> bool:
	if path.is_empty():
		return false
	var base_path: String = path.get_base_dir()
	var dir = DirAccess.open(base_path)
	if dir:
		return dir.dir_exists(base_path)
	return false


static func is_valid_parent_path(path: String) -> bool:
	if path.is_empty():
		return false
	var base_path = path.get_base_dir()
	if base_path.is_empty():
		return false
	if base_path == ".":
		if !path.begins_with("res://") and !path.begins_with("user://"):
			return false     
	return DirAccess.dir_exists_absolute(base_path)

	
static func is_avatar_file(path: String) -> bool:
	var file_path = path.get_base_dir()
	var file_name = path.get_file()
	if !is_valid_path(file_path):
		return false
	if file_name:
		var name_split: PackedStringArray = file_name.split(".")
		if name_split.size() > 1:
			if name_split[1] == "glb":
				if FileAccess.file_exists(path):
					return true
	return false
	
	
static func is_image_file(path: String) -> bool:
	var file_name = path.get_file()
	if file_name:
		var name_split: PackedStringArray = file_name.split(".")
		if name_split.size() > 1:
			if name_split[1] == "bmp" or name_split[1] == "jpg" or name_split[1] == "png" or name_split[1] == "tga":
				if FileAccess.file_exists(path):
					return true
	return false
	
	
static func is_valid_name(name: String) -> bool:
	if name.length() < NAME_MIN_CHAR:
		return false
	if name.length() > NAME_MAX_CHAR:
		return false
	if !name.is_valid_filename():
		return false
	return true
