@tool
extends EditorPlugin

var dock: Control


func create_dock():
	dock = Control.new()
	dock.add_child(AWOCEditor.new())
	dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	
func destroy_dock():
	if dock != null:
		remove_control_from_docks(dock)
		dock.free()

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		create_dock()


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		destroy_dock()
