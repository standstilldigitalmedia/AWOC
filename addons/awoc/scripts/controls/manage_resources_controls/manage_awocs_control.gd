@tool
class_name ManageAWOCsControl extends AWOCManageResourcesControlBase

signal awoc_edited(awoc: AWOCResourceControllerBase)

func on_awoc_edited(awoc: AWOCResourceControllerBase):
	awoc_edited.emit(awoc)

func populate_manage_resources_container():
	super()
	for awoc_name in dictionary:
		var controller: AWOCResourceControllerBase = AWOCResourceControllerBase.new(awoc_name, dictionary, dictionary[awoc_name], "")
		var control = AWOCControl.new(controller)
		manage_resources_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)
		control.awoc_edited.connect(on_awoc_edited)
