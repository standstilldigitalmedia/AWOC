@tool
class_name AWOCWelcomeTab extends AWOCTabBase

signal awoc_edited(awoc: AWOCDiskResourceController)
var tab_label

func parent_tab_controls():
	controls_vbox.add_child(tab_label)
	super()
	
func create_tab_controls():
	tab_label = create_label("Welcome")
	super()

func populate_manage_resources_container():
	super()
	for awoc in resource_controller.dictionary:
		var controller: AWOCDiskResourceController = AWOCDiskResourceController.new(load(ResourceUID.get_id_path(resource_controller.dictionary[awoc])),resource_controller.resource_controller,resource_controller.dictionary)
		var control = AWOCManageAWOCControl.new(controller)
		manage_resources_inner_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)
		control.awoc_edited.connect(on_awoc_edited)
	
func on_awoc_edited(awoc: AWOCDiskResourceController):
	awoc_edited.emit(awoc)
	
func create_new_resource_control():
	new_resource_control = AWOCNewAWOCControl.new(resource_controller)
	super()
