@tool
class_name AWOCGlobalState
extends Node

signal awoc_loaded(awoc_name: String)
signal awoc_closed
signal awoc_data_changed

var current_awoc: AWOCResource = null
var current_asset_path: String = "res://"


func load_awoc(awoc_name: String) -> bool:
	var awoc_library_manager: AWOCLibraryManager = AWOCManager.awoc_resource_manager
	if !awoc_library_manager:
		push_error("AWOCLibrary manager not set")
		return false

	print("DEBUG load_awoc: Loading AWOC named: ", awoc_name)

	var path: String = awoc_library_manager.get_awoc_path(awoc_name)
	print("DEBUG load_awoc: Path resolved to: ", path)

	if !path.is_empty():
		if !FileAccess.file_exists(path):
			push_error("AWOC file not found: " + path)
			return false

		print("DEBUG load_awoc: File exists, attempting to load...")
		var loaded_awoc = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		print("DEBUG load_awoc: Loaded resource: ", loaded_awoc)
		print(
			"DEBUG load_awoc: Resource type: ",
			type_string(typeof(loaded_awoc)) if loaded_awoc else "null"
		)

		if !loaded_awoc or !loaded_awoc is AWOCResource:
			push_error("Failed to load AWOC or invalid resource type: " + path)
			return false
		current_awoc = loaded_awoc
		current_asset_path = path.get_base_dir()
		var current_awoc_uid: int = awoc_library_manager.get_awoc_uid(awoc_name)
		AWOCManager.slot_resource_manager.init_resource_manager(
			current_awoc, current_awoc_uid, current_awoc.slot_dictionary
		)
		awoc_loaded.emit(awoc_name)
		return true
	return false


func unload_current_awoc():
	current_awoc = null
	awoc_closed.emit()
