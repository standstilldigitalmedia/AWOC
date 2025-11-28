@tool
class_name AWOCWelcomeTab
extends AWOCTabBase


func set_manage_button_state() -> void:
	set_manage_button_type(AWOCResourceType.Type.AWOC)
	
	
func _ready() -> void:
	set_manage_button_state()
	super._ready()
