@tool
class_name AWOCManageHideSlotsControl extends AWOCManageResourcesControlBase

func populate_manage_resources_container():
	super()
	"""for slot in dictionary:
		var controller: AWOCResourceControllerBase = AWOCResourceControllerBase.new(slot, dictionary, 0, "")
		var control = AWOCSlotControl.new(controller)
		manage_resources_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)"""
