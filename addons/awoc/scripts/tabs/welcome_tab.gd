@tool
class_name AWOCWelcomeTab extends AWOCTabBase

signal awoc_edited(awoc: AWOCDiskResourceController)

var tab_label
var awoc_manager_resource_controller

func parent_controls():
	controls_vbox.add_child(tab_label)
	super()
	
func create_controls():
	tab_label = create_label("Welcome")
	super()

func populate_manage_resources_container():
	super()
	for awoc in awoc_manager_resource_controller.dictionary:
		var controller: AWOCResourceController = AWOCResourceController.new(load(ResourceUID.get_id_path(awoc_manager_resource_controller.dictionary[awoc])),awoc_manager_resource_controller)
		var control = AWOCManageAWOCControl.new(controller)
		manage_resources_inner_vbox.add_child(control.main_panel_container)
		control.resource_renamed.connect(on_resource_renamed)
		control.resource_deleted.connect(on_resource_deleted)
		control.awoc_edited.connect(on_awoc_edited)
	
func on_awoc_edited(awoc: AWOCResourceController):
	awoc_edited.emit(awoc)
	
func create_new_resource_control():
	new_resource_control = AWOCNewAWOCControl.new(awoc_manager_resource_controller)
	super()
	
func on_manage_resources_button_toggled(toggled_on: bool):
	if toggled_on:
		populate_manage_resources_container()
	super(toggled_on)
	
func set_manage_button_disabled():
	if awoc_manager_resource_controller.dictionary.size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		manage_resources_panel_container.visible = false
	
func _init(r_controller: AWOCManagerController):
	awoc_manager_resource_controller = r_controller
	super()
