@tool
extends EditorPlugin

var dock: Control
const EDITOR_UI_SCENE_PATH: String = "res://addons/AWOC/Scenes/AWOCEditor/awoc_editor.tscn"

func _enter_tree():
	dock = preload(EDITOR_UI_SCENE_PATH).instantiate()
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
