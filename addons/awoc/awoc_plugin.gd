@tool
class_name AWOCPlugin extends EditorPlugin

const SEND_TO_RECYCLE = false
const SCAN_ON_FILE_CHANGE = true
const NAME_MIN_CHAR = 4
const IMAGE_BASE_DIR: String = "res://addons/awoc/images/godot_icons/"

var plugin
var dock: Control
var awoc_manager: AWOCManager
var tool_menu_set: String

func _build():
	var awoc_manager_controller = AWOCManagerResourceController.new()
	

func create_tool_menu():
	var popup = PopupMenu.new()
	popup.add_item("Delete AWOC Manager", 0)
	#popup.id_pressed.connect(delete_awoc_manager)
	add_tool_submenu_item("AWOC",popup)
	tool_menu_set = "set"

func destroy_tool_menu():
	if tool_menu_set == "set":
		remove_tool_menu_item("AWOC")
		
func create_dock():
	dock = Control.new()
	var avatar_file = load("res://test_model.glb")
	var avatar = avatar_file.instantiate()
	#dock.add_child(AWOCPreviewControl.new(avatar))
	dock.add_child(AWOCEditor.new().scroll_container)
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()
	
func create_inspector_plugin():
	#plugin = AWOCEditorInspectorPlugin.new()
	add_inspector_plugin(plugin)
		
func destroy_inspector_plugin():
	if plugin != null:
		remove_inspector_plugin(plugin)
		
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		create_tool_menu()
		#create_inspector_plugin()
		create_dock()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		destroy_dock()
		#destroy_inspector_plugin()
		destroy_tool_menu()
