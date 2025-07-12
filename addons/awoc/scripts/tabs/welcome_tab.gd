@tool
class_name AWOCWelcomeTab extends AWOCTabBase

signal awoc_edited(awoc_resource_controller: AWOCResourceController)

var awoc_manager_resource_controller: AWOCManagerResourceController

func emit_awoc_edited(awoc_resource_controller: AWOCResourceController):
	awoc_edited.emit(awoc_resource_controller)
	
func parent_controls():
	var vbox = create_vbox(10)
	vbox.add_child(create_label("Welcome"))
	vbox.add_child(new_resource_control)
	vbox.add_child(manage_resources_control)
	add_child(vbox)

func _init():
	awoc_manager_resource_controller = AWOCManagerResourceController.new()
	new_resource_control = AWOCNewAWOCControl.new(awoc_manager_resource_controller)
	manage_resources_control = AWOCManageAWOCsControl.new(awoc_manager_resource_controller)
	manage_resources_control.awoc_edited.connect(emit_awoc_edited)
	super()
