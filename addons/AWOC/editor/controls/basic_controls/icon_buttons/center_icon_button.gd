@tool
class_name AWOCCenterIconButton
extends AWOCIconButton

func _init() -> void:
	super()
	icon = load(AWOCGlobal.ICON_IMAGE_BASE_PATH + "CenterView.svg")
