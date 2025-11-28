@tool
class_name AWOCEditorGlobal
extends Node

const WELCOME_BASE_PATH: String = "begin_here/"
const WELCOME_FILE_NAME: String = "welcome.tres"
const SCAN_ON_FILE_CHANGE: bool = true
const SEND_TO_RECYCLE: bool = false
static var plugin_path: String = "res://addons/AWOC/"
const AWOC_MANAGER_PATH: String = "/root/AWOCManager"
const AWOC_STATE_PATH: String = "/root/AWOCState"
const SIGNAL_BUS_PATH: String = "/root/SignalBus"
const AWOC_ROW_PATH: String = "editor/UI_elements/row_management/awoc_row_management/awoc_row_management.tscn"
const MESH_ROW_PATH: String = "editor/UI_elements/row_management/mesh_row_management/mesh_row_management.tscn"
const SLOT_ROW_PATH: String = "editor/UI_elements/row_management/slot_row_management/slot_row_management.tscn"
const ADDITIONAL_DATA_PATH: String = "path"


static func get_awoc_manager() -> AWOCGlobalManager:
	var main_loop = Engine.get_main_loop()
	if main_loop is SceneTree:
		var global_manager: AWOCGlobalManager = main_loop.root.get_node_or_null(AWOC_MANAGER_PATH) as AWOCGlobalManager
		if global_manager:
			return global_manager
	push_error("Auto loaded AWOCManager could not be found.")
	return null
	
	
static func get_awoc_state() -> AWOCGlobalState:
	var main_loop = Engine.get_main_loop()
	if main_loop is SceneTree:
		var global_state: AWOCGlobalState = main_loop.root.get_node_or_null(AWOC_STATE_PATH) as AWOCGlobalState
		if global_state:
			return global_state
	push_error("Auto loaded AWOCState could not be found") 
	return null
	
	
static func get_signal_bus() -> AWOCGlobalSignalBus:
	var main_loop = Engine.get_main_loop()
	if main_loop is SceneTree:
		var signal_bus: AWOCGlobalSignalBus = main_loop.root.get_node_or_null(SIGNAL_BUS_PATH) as AWOCGlobalSignalBus
		if signal_bus:
			return signal_bus
	push_error("Auto loaded SignalBus could not be found")
	return null
