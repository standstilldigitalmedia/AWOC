@tool
class_name AWOCPlugin extends EditorPlugin

const SEND_TO_RECYCLE = false
const SCAN_ON_RELOAD = true

var plugin
var dock: Control
var awoc_manager_resource_controller: AWOCDiskResourceController
var tool_menu_set: String

func load_awoc_manager():
	if FileAccess.file_exists(AWOCManager.AWOC_MANAGER_PATH):
		var awoc_manager = load(AWOCManager.AWOC_MANAGER_PATH)
		awoc_manager_resource_controller = AWOCDiskResourceController.new(awoc_manager,awoc_manager,awoc_manager.awoc_uid_dictionary)
	else:
		var awoc_manager = AWOCManager.new()
		awoc_manager_resource_controller = AWOCDiskResourceController.new(awoc_manager,awoc_manager,{})
		awoc_manager_resource_controller.create_resource(AWOCManager.AWOC_MANAGER_PATH)
		awoc_manager_resource_controller.dictionary = awoc_manager.awoc_uid_dictionary
		
func add_tool_menu():
	var popup = PopupMenu.new()
	popup.add_item("Create New AWOC", 0)
	#popup.id_pressed.connect(open_window)
	add_tool_submenu_item("AWOC",popup)
	tool_menu_set = "set"
		
func create_dock():
	dock = Control.new()
	dock.add_child(AWOCEditor.new(awoc_manager_resource_controller, true).main_panel_container)
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
func create_inspector_plugin():
	plugin = AWOCEditorInspectorPlugin.new()
	add_inspector_plugin(plugin)
		
func remove_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()
		
func remove_awoc_inspector_plugin():
	if plugin != null:
		remove_inspector_plugin(plugin)
		
func remove_tool_menu():
	if tool_menu_set == "set":
		remove_tool_menu_item("AWOC")
		
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		load_awoc_manager()
		add_tool_menu()
		create_inspector_plugin()
		create_dock()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		remove_dock()
		remove_awoc_inspector_plugin()
		remove_tool_menu()
