@tool
class_name AWOCColorTab
extends AWOCTabBase


func _init(awoc_reference: AWOCEditorResourceReference) -> void:
	_resource_controller = AWOCColorController.new(awoc_reference)
	super()


func _create_controls() -> void:
	super()
	_new_resource_button = create_toggle_text_button("New Color")
	_manage_resources_button = create_toggle_text_button("Manage Colors")
	_new_resource_control = AWOCNewColorControl.new()
	
	
func _set_listeners() -> void:
	super()
	_new_resource_control.new_resource.connect(_on_new_resource)


func _on_new_resource(color_name: String, color: Color) -> void:
	_resource_controller.add_new_color(color_name, color)
	set_manage_resources_button_disabled()
	populate_manage_controls()
	

func _on_color_update(color_name: String, new_color: Color) -> void:
	_resource_controller.update_color(color_name, new_color)
	
	
func populate_manage_controls() -> void:
	super()
	for resource_name: String in _resource_controller._get_dictionary():
		var resource_control: AWOCManageColorControl = AWOCManageColorControl.new(resource_name)
		var editor_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(_resource_controller._get_dictionary()[resource_name])
		resource_control._color_picker_button.color = editor_reference.load_res().color
		resource_control.color_updated.connect(_on_color_update)
		add_manage_resource_control_and_set_listeners(resource_control)
