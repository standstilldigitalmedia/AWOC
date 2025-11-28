@tool
class_name AWOCPlugin
extends EditorPlugin

var dock: Control
var main_editor_window_scene: PackedScene
var main_editor_path: String = ""
var signal_bus_path: String = ""
var signal_bus_name: String = "SignalBus"
var awoc_state_path: String = ""
var awoc_state_name: String = "AWOCState"
var awoc_manager_path: String = ""
var awoc_manager_name: String = "AWOCManager"


func update_plugin_path() -> void:
	var script_path = get_script().resource_path
	var root_dir = script_path.get_base_dir()
	AWOCEditorGlobal.plugin_path = root_dir


func set_autoloader_paths() -> void:
	main_editor_path = AWOCEditorGlobal.plugin_path.path_join("editor/UI_elements/main_editor_interface/main_editor_interface.tscn")
	signal_bus_path = AWOCEditorGlobal.plugin_path.path_join("editor/autoload/global_signal_bus.gd")
	awoc_state_path = AWOCEditorGlobal.plugin_path.path_join("editor/autoload/global_state.gd")
	awoc_manager_path = AWOCEditorGlobal.plugin_path.path_join("editor/autoload/global_manager.gd")


func load_autoload(name: String, path: String) -> void:
	var autoload_setting_path = "autoload/" + name
	if !ProjectSettings.has_setting(autoload_setting_path):
		add_autoload_singleton(name, path)
	else:
		pass


func unload_autoload(name: String) -> void:
	var autoload_setting_path = "autoload/" + name
	if ProjectSettings.has_setting(autoload_setting_path):
		remove_autoload_singleton(name)


func create_dock():
	if dock != null:
		push_warning("AWOC: Dock already exists, skipping creation")
		return
	dock = Control.new()
	main_editor_window_scene = load(main_editor_path)
	if main_editor_window_scene:
		var main_editor_window := main_editor_window_scene.instantiate() as AWOCMainEditorInterface
		if main_editor_window != null:
			dock.add_child(main_editor_window)
			dock.name = "AWOC"
			add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	else:
		push_error("AWOC: Could not load main editor scene at " + main_editor_path)


func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()


func _enter_tree() -> void:
	update_plugin_path()
	set_autoloader_paths()
	load_autoload(signal_bus_name, signal_bus_path)
	load_autoload(awoc_state_name, awoc_state_path)
	load_autoload(awoc_manager_name, awoc_manager_path)
	await get_tree().process_frame
	await get_tree().process_frame
	if not is_inside_tree():
		push_warning("AWOC: Plugin removed from tree before initialization completed")
		return
	create_dock()


func _exit_tree() -> void:
	destroy_dock()
	
	
func _disable_plugin() -> void:
	unload_autoload(awoc_state_name)
	unload_autoload(awoc_manager_name)
	unload_autoload(signal_bus_name)
