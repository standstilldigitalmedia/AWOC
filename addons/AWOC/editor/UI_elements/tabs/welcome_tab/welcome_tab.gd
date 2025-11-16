@tool
class_name AWOCWelcomeTab
extends AWOCTabBase

var welcome_resource: AWOCEditorWelcomeResourceManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	welcome_resource = AWOCEditorWelcomeResourceManager.new().load_welcome_resource_manager()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
