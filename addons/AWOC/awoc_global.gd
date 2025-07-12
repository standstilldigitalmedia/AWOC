@tool
class_name AWOCGlobal
extends Node

const SCAN_ON_FILE_CHANGE: bool = true
const SEND_TO_RECYCLE: bool = false
const NAME_MIN_CHAR: int = 4
const WELCOME_RESOURCE_PATH: String = "res://addons/AWOC/begin_here/welcome.res"
const ICON_IMAGE_BASE_PATH: String = "res://addons/AWOC/editor/images/godot_icons/"
const FOLDER_CONTROL_OVERRIDE_PATH: String = "res://addons/AWOC/editor/control_overrides/folder_control_override.gd"
const IMAGE_CONTROL_OVERRIDE_PATH: String = "res://addons/AWOC/editor/control_overrides/image_control_override.gd"
const MULTI_MESH_CONTROL_OVERRIDE_PATH: String = "res://addons/AWOC/editor/control_overrides/multiple_mesh_control_override.gd"
const SINLE_MESH_CONTROL_OVVERIDE_PATH: String = "res://addons/AWOC/editor/control_overrides/single_mesh_control_override.gd"


static func scan():
	if SCAN_ON_FILE_CHANGE:
		EditorInterface.get_resource_filesystem().scan()


static func is_valid_path(path: String) -> bool:
	if path == "":
		return false
	var base_path: String = path.get_base_dir()
	var dir = DirAccess.open(base_path)
	if dir:
		return dir.dir_exists(base_path)
	return false

	
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
	if !name.is_valid_filename():
		return false
	return true
