@tool
extends EditorPlugin

var dock: Control
var main_editor_window_scene := preload("res://addons/AWOC/editor/UI_elements/main_editor_interface/main_editor_interface.tscn")
const SIGNAL_BUS_PATH: String = "res://addons/AWOC/editor/autoload/global_signal_bus.gd"
const SIGNAL_BUS_NAME: String = "SignalBus"
const AWOC_STATE_PATH: String = "res://addons/AWOC/editor/autoload/awoc_state.gd"
const AWOC_STATE_NAME: String = "AWOCState"
const AWOC_MANAGER_PATH: String = "res://addons/AWOC/editor/autoload/awoc_manager.gd"
const AWOC_MANAGER_NAME: String = "AWOCManager"


func load_awoc_manager() -> void:
	var autoload_setting_path = "autoload/" + AWOC_MANAGER_NAME
	if !ProjectSettings.has_setting(autoload_setting_path):
		add_autoload_singleton(AWOC_MANAGER_NAME, AWOC_MANAGER_PATH)

		
func unload_awoc_manager() -> void:
	var autoload_setting_path = "autoload/" + AWOC_MANAGER_NAME
	if ProjectSettings.has_setting(autoload_setting_path):
		remove_autoload_singleton(AWOC_MANAGER_NAME)
		
		
func load_awoc_state() -> void:
	var autoload_setting_path = "autoload/" + AWOC_STATE_NAME
	if !ProjectSettings.has_setting(autoload_setting_path):
		add_autoload_singleton(AWOC_STATE_NAME, AWOC_STATE_PATH)

		
func unload_awoc_state() -> void:
	var autoload_setting_path = "autoload/" + AWOC_STATE_NAME
	if ProjectSettings.has_setting(autoload_setting_path):
		remove_autoload_singleton(AWOC_STATE_NAME)


func load_signal_bus() -> void:
	var autoload_setting_path = "autoload/" + SIGNAL_BUS_NAME
	if !ProjectSettings.has_setting(autoload_setting_path):
		add_autoload_singleton(SIGNAL_BUS_NAME, SIGNAL_BUS_PATH)
	
		
func unload_signal_bus() -> void:
	var autoload_setting_path = "autoload/" + SIGNAL_BUS_NAME
	if ProjectSettings.has_setting(autoload_setting_path):
		remove_autoload_singleton(SIGNAL_BUS_NAME)


func create_dock():
	dock = Control.new()
	var main_editor_window := main_editor_window_scene.instantiate() as AWOCMainEditorInterface
	dock.add_child(main_editor_window)
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
	
func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		load_signal_bus()
		load_awoc_manager()
		load_awoc_state()
		create_dock()


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		destroy_dock()
		unload_awoc_state()
		unload_awoc_manager()
		unload_signal_bus()
