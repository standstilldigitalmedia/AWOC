@tool
class_name AWOCManagerEditorProperty extends EditorProperty

func _init(awoc_manager_resource_controller: AWOCResourceControllerBase):
	var tab_control = AWOCEditor.new(awoc_manager_resource_controller, false)
	var vbox = VBoxContainer.new()
	vbox.add_child(tab_control.main_panel_container)
	for child in get_children():
		child.queue_free()
	add_child(vbox)
	set_bottom_editor(vbox)

func _update_property():
	label = ""
