@tool
class_name AWOCEditorProperty extends EditorProperty

var updating = false
var tab_bar: TabBar
var awoc_resource_controller: AWOCResourceControllerBase

func _init(r_awoc_resource_controller: AWOCResourceControllerBase):
	awoc_resource_controller = r_awoc_resource_controller
	var tab_control = AWOCTabBarTab.new(awoc_resource_controller)
	for child in get_children():
		child.queue_free()
	add_child(tab_control.main_panel_container)
	set_bottom_editor(tab_control.main_panel_container)
	
func _update_property():
	label = ""
