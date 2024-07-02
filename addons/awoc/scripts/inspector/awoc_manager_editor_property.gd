class_name AWOCManagerEditorProperty extends EditorProperty

var updating = false
#var tab_control: AWOCTabBase

func _init(awoc_manager_resource_controller: AWOCDiskResourceController):
	var tab_control = AWOCEditor.new(awoc_manager_resource_controller, false)
	var vbox = VBoxContainer.new()
	vbox.add_child(tab_control.main_panel_container)
	for child in get_children():
		child.queue_free()
	add_child(vbox)
	set_bottom_editor(vbox)
	
func _on_add_resource_button_pressed():
	if (updating):
		return

func _update_property():
	label = ""
