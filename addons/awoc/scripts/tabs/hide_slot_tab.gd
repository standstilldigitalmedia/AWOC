@tool
class_name AWOCHideSlotTab extends AWOCTabBase

func reset_tab():
	if resource_controller.resource_controller.slots_uid_dictionary.size() > 0:
		new_resource_button.disabled = false
	else:
		new_resource_button.disabled = true
	super()
	
func create_new_resource_control():
	#new_resource_control = AWOCNewAWOCControl.new(resource_controller)
	#super()
	pass
