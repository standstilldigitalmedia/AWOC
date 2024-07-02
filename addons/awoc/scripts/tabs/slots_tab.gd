@tool
class_name AWOCSlotsTab extends AWOCTabBase

func populate_manage_resources_container():
	super()
	for slot in resource_controller.dictionary:
		var controller: AWOCDictionaryResourceController = AWOCDictionaryResourceController.new(resource_controller.dictionary[slot],resource_controller.resource_controller,resource_controller.resource_controller.slots_uid_dictionary)
		var control = AWOCManageAWOCControl.new(controller)
		manage_resources_inner_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)

func create_new_resource_control():
	new_resource_control = AWOCNewSlotControl.new(resource_controller)
	super()
