@tool
class_name AWOCGlobalManager
extends Node

var awoc_resource_manager: AWOCEditorAWOCResourceManager

func _on_create_resource(data: Dictionary) -> void:
	if !data.has("type") or data.get("type").is_empty():
		return
	match data.get("type"):
		"awoc":
			var name = data.get("name", "")
			if name.is_empty():
				push_error("AWOC name required for AWOC creation")
				return
			var path = data.get("path", "")
			if path.is_empty():
				push_error("Path required for AWOC creation")
				return
			var new_awoc: AWOCResource = awoc_resource_manager.add_new_awoc(name, path)
			if new_awoc == null:
				push_error("New awoc could not be created")
				return
			AWOCState.set_current_awoc(new_awoc)
		
		
func _on_rename_resource(resource_type: String, old_name: String, new_name: String) -> void:
	match resource_type:
		"awoc":
			awoc_resource_manager.rename_awoc(old_name,new_name)
			
		
func _on_delete_resource(resource_type: String, resource_name: String) -> void:
	match resource_type:
		"awoc":
			awoc_resource_manager.delete_awoc(resource_name)
		
		
func _ready() -> void:
	awoc_resource_manager = AWOCEditorAWOCResourceManager.new().load_welcome_resource_manager()
	SignalBus.create_new_resource_requested.connect(_on_create_resource)
	SignalBus.delete_resource_requested.connect(_on_delete_resource)
	SignalBus.rename_resource_requested.connect(_on_rename_resource)
