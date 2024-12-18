@tool
class_name AWOCManageSlotControl
extends AWOCManageControlBase
	
	
func _create_controls() -> void:
	super()
	_name_line_edit = create_line_edit("Slot Name", _resource_name)
	
	
func _parent_controls() -> void:
	super()
	_controls_hbox.add_child(_name_line_edit)
	_controls_hbox.add_child(_rename_button)
	_controls_hbox.add_child(_delete_button)
	_controls_hbox.add_child(_show_button)
	_controls_hbox.add_child(_hide_button)
