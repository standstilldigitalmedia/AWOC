@tool
class_name AWOCPlugin extends EditorPlugin

const SEND_TO_RECYCLE = false
const SCAN_ON_FILE_CHANGE = true

var plugin
var dock: Control
var awoc_manager_controller: AWOCResourceControllerBase
var tool_menu_set: String

static func scan():
	if SCAN_ON_FILE_CHANGE:
		EditorInterface.get_resource_filesystem().scan()

func load_awoc_manager():
	if FileAccess.file_exists(AWOCManager.AWOC_MANAGER_PATH):
		awoc_manager_controller = AWOCResourceControllerBase.new("", {}, 0, AWOCManager.AWOC_MANAGER_PATH)
		awoc_manager_controller.dictionary = awoc_manager_controller.resource.awoc_uid_dictionary
	else:
		var awoc_manager = AWOCManager.new()
		awoc_manager_controller = AWOCResourceControllerBase.new("", awoc_manager.awoc_uid_dictionary,0, "")
		awoc_manager_controller.resource = awoc_manager
		awoc_manager_controller.path = AWOCManager.AWOC_MANAGER_PATH
		awoc_manager_controller.create_resource_on_disk()
		
func create_tool_menu():
	var popup = PopupMenu.new()
	popup.add_item("Create New AWOC", 0)
	#popup.id_pressed.connect(open_window)
	add_tool_submenu_item("AWOC",popup)
	tool_menu_set = "set"

func destroy_tool_menu():
	if tool_menu_set == "set":
		remove_tool_menu_item("AWOC")
		
func create_dock():
	dock = Control.new()
	dock.add_child(AWOCEditor.new(awoc_manager_controller, true).scroll_container)
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()
	
func create_inspector_plugin():
	plugin = AWOCEditorInspectorPlugin.new()
	add_inspector_plugin(plugin)
		
func destroy_inspector_plugin():
	if plugin != null:
		remove_inspector_plugin(plugin)
		
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		load_awoc_manager()
		create_tool_menu()
		create_inspector_plugin()
		create_dock()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		destroy_dock()
		destroy_inspector_plugin()
		destroy_tool_menu()
