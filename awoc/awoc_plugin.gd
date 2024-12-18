@tool
class_name AWOCPlugin 
extends EditorPlugin

var _dock: Control
	

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		create_dock()


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		destroy_dock()
		
					
func create_dock() -> void:
	_dock = Control.new()
	_dock.add_child(AWOCDock.new())
	_dock.name = "AWOC"
	add_control_to_dock(DOCK_SLOT_LEFT_UR, _dock)
	
	
func destroy_dock() -> void:
	if _dock != null:
		remove_control_from_docks(_dock)
		_dock.free()
