@tool
class_name AWOCRenameIconButton
extends AWOCIconButton


func _init() -> void:
	super()
	icon = load(AWOCGlobal.ICON_IMAGE_BASE_PATH + "Save.svg")
