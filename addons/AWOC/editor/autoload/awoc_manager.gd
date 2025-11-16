@tool
extends Node

func _on_create_resource(data: Dictionary) -> void:
	if !data.has("type"):
		return
	if data.get("type") == "awoc":
		var awoc_resource_manager: AWOCEditorAWOCResourceManager = AWOCEditorAWOCResourceManager.new().load_welcome_resource_manager()
		var new_awoc: AWOCResource = awoc_resource_manager.add_new_awoc(data.get("name"), data.get("path"))
		AWOCState.set_current_awoc(new_awoc)
		

func _ready() -> void:
	SignalBus.create_new_resource_requested.connect(_on_create_resource)
