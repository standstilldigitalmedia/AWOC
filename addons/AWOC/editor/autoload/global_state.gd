@tool
class_name AWOCGlobalState
extends Node

signal awoc_loaded(awoc_name: String)
signal awoc_closed
signal awoc_data_changed

var current_awoc: AWOCResource = null
var current_asset_path: String = "res://"


func load_awoc(awoc_name: String) -> bool:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return false
	var awoc_library_manager: AWOCLibraryManager = awoc_manager.awoc_resource_manager
	if !awoc_library_manager:
		push_error("AWOCLibrary manager not set")
		return false
	var path: String = awoc_library_manager.get_awoc_path(awoc_name)
	if !path.is_empty():
		if !FileAccess.file_exists(path):
			push_error("AWOC file not found: " + path)
			return false
		var loaded_awoc = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if !loaded_awoc or !loaded_awoc is AWOCResource:
			push_error("Failed to load AWOC or invalid resource type: " + path)
			return false
		current_awoc = loaded_awoc
		current_asset_path = path.get_base_dir()
		awoc_loaded.emit(awoc_name)
		return true
	return false


func unload_current_awoc():
	current_awoc = null
	awoc_closed.emit()
