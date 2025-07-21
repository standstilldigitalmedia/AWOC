@tool
class_name AWOCEditIconButton
extends AWOCIconButton

func _init() -> void:
	super()
	icon = load(AWOCGlobal.ICON_IMAGE_BASE_PATH + "Edit.svg")
