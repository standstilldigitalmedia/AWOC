@tool
class_name AWOCGlobal
extends Node

const MINIMUM_NAME_CHARACTERS: int = 4
const SEND_TO_RECYCLE: bool = false
const SCAN_ON_FILE_CHANGE: bool = true

const IMAGES_BASE_DIRECTORY: String = "res://addons/awoc/editor/images/"
const ICON_BASE_DIRECTORY: String = IMAGES_BASE_DIRECTORY + "godot_icons/"

const NO_IMAGE: Texture2D = preload(IMAGES_BASE_DIRECTORY + "no_image.png")
const BLANK_IMAGE: Texture2D = preload(IMAGES_BASE_DIRECTORY + "blank.png")

const ADD_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "Add.svg")
const ARROW_DOWN_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "ArrowDown.svg")
const ARROW_LEFT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "ArrowLeft.svg")
const ARROW_RIGHT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "ArrowRight.svg")
const ARROW_UP_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "ArrowUp.svg")
const CENTER_VIEW_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "CenterView.svg")
const ZOOM_OUT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "CurveConstant.svg")
const EDIT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "Edit.svg")
const BROWSE_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "Folder.svg")
const HIDE_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "GuiVisibilityHidden.svg")
const SHOW_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "GuiVisibilityVisible.svg")
const DELETE_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "Remove.svg")
const ROTATE_LEFT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "RotateLeft.svg")
const ROTATE_RIGHT_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "RotateRight.svg")
const RENAME_ICON: Texture2D = preload(ICON_BASE_DIRECTORY + "Save.svg")


static func is_valid_name(name: String) -> bool:
	if name.length() < MINIMUM_NAME_CHARACTERS:
		return false
	if !name.is_valid_identifier():
		return false
	return true
	
	
static func is_valid_path(path: String) -> bool:
	var dir = DirAccess.open(path)
	if dir:
		return true
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
