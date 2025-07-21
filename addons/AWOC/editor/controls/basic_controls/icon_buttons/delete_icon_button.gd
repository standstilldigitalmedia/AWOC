@tool
class_name AWOCDeleteIconButton
extends AWOCIconButton


func _init() -> void:
	super()
	icon = load(AWOCGlobal.ICON_IMAGE_BASE_PATH + "Remove.svg")
