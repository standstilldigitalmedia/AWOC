@tool
class_name AWOCPlugin
extends EditorPlugin

var dock: Control
var main_editor_window_scene := preload("res://addons/AWOC/editor/UI_elements/main_editor_interface/main_editor_interface.tscn")
const SIGNAL_BUS_PATH: String = "res://addons/AWOC/editor/autoload/global_signal_bus.gd"
const SIGNAL_BUS_NAME: String = "SignalBus"
const AWOC_STATE_PATH: String = "res://addons/AWOC/editor/autoload/awoc_state.gd"
const AWOC_STATE_NAME: String = "AWOCState"
const AWOC_MANAGER_PATH: String = "res://addons/AWOC/editor/autoload/awoc_manager.gd"
const AWOC_MANAGER_NAME: String = "AWOCManager"


func load_autoload(name: String, path: String) -> void:
	var autoload_setting_path = "autoload/" + name
	if !ProjectSettings.has_setting(autoload_setting_path):
		add_autoload_singleton(name, path)


func unload_autoload(name: String) -> void:
	var autoload_setting_path = "autoload/" + name
	if ProjectSettings.has_setting(autoload_setting_path):
		remove_autoload_singleton(name)
		

func create_dock():
	dock = Control.new()
	var main_editor_window := main_editor_window_scene.instantiate() as AWOCMainEditorInterface
	if main_editor_window != null:
		dock.add_child(main_editor_window)
		dock.name = "AWOC"
		add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
	
func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()
		

func _enter_tree() -> void:
	load_autoload(SIGNAL_BUS_NAME, SIGNAL_BUS_PATH)
	load_autoload(AWOC_MANAGER_NAME, AWOC_MANAGER_PATH)
	load_autoload(AWOC_STATE_NAME, AWOC_STATE_PATH)
	create_dock()


func _exit_tree() -> void:
	destroy_dock()
	unload_autoload(SIGNAL_BUS_NAME)
	unload_autoload(AWOC_MANAGER_NAME)
	unload_autoload(AWOC_STATE_NAME)
