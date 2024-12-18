@tool
class_name AWOCWelcomeTab
extends AWOCTabBase

signal awoc_edited(awoc_name: String, awoc_resource_reference: AWOCResourceReference)


func _init() -> void:
	_resource_controller = AWOCManagerController.new()
	super()


func _create_controls() -> void:
	super()
	_new_resource_button = create_toggle_text_button("New AWOC")
	_manage_resources_button = create_toggle_text_button("Manage AWOCs")
	_new_resource_control = AWOCNewAWOCControl.new()
	
	
func _set_listeners() -> void:
	super()
	_new_resource_control.new_resource.connect(_on_new_resource)


func _on_new_resource(name: String, path: String) -> void:
	_resource_controller.add_new_awoc(name, path)
	set_manage_resources_button_disabled()
	populate_manage_controls()
	

func _on_resource_edited(resource_name: String) -> void:
	awoc_edited.emit(
			resource_name, 
			_resource_controller.get_reference(resource_name))
	
		
func populate_manage_controls() -> void:
	super()
	for resource_name: String in _resource_controller._get_dictionary():
		var resource_control: AWOCManageAWOCControl = AWOCManageAWOCControl.new(resource_name)
		add_manage_resource_control_and_set_listeners(resource_control)
		resource_control.resource_edited.connect(_on_resource_edited)
