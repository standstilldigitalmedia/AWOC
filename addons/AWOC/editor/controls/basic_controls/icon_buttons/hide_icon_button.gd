@tool
class_name AWOCHideIconButton
extends AWOCIconButton


func _init() -> void:
	super()
	icon = load(AWOCGlobal.ICON_IMAGE_BASE_PATH + "GuiVisibilityHidden.svg")
