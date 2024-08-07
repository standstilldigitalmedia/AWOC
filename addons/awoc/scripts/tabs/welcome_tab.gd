@tool
class_name AWOCWelcomeTab extends AWOCTabBase

signal awoc_edited(awoc: AWOCResourceControllerBase)

var awoc_manager_resource_controller: AWOCResourceControllerBase
	
func create_controls():
	new_resource_control = AWOCNewAWOCControl.new(awoc_manager_resource_controller)
	manage_resources_control = ManageAWOCsControl.new(awoc_manager_resource_controller.resource.awoc_uid_dictionary)
	super()
	
func set_manage_button_disabled():
	if awoc_manager_resource_controller.dictionary.size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		manage_resources_panel_container.visible = false
		
func on_resource_deleted():
	super()
	awoc_manager_resource_controller.save_resource()
	
func on_resource_renamed():
	awoc_manager_resource_controller.save_resource()
	
func on_awoc_edited(awoc: AWOCResourceControllerBase):
	awoc_edited.emit(awoc)
	
func set_tab_listeners():
	super()
	manage_resources_control.awoc_edited.connect(on_awoc_edited)
	
func _init(r_controller: AWOCResourceControllerBase):
	awoc_manager_resource_controller = r_controller
	super()
