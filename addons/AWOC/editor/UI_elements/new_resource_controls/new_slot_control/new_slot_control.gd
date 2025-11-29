@tool
class_name AWOCNewSlotControl
extends AWOCNewResourceControlBase

@export var name_line_edit: LineEdit
@export var create_button: Button


func disable_inputs(disable: bool) -> void:
	name_line_edit.editable = !disable
	create_button.disabled = disable


func reset_inputs() -> void:
	name_line_edit.text = ""
	create_button.disabled = true


func validate() -> void:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	var name_is_valid = AWOCValidator.is_valid_name(name_line_edit.text)
	var name_exists = awoc_manager.has_named_resource(AWOCResourceType.Type.SLOT, name_line_edit.text)
	if not name_is_valid:
		set_error("Please enter a valid name for your Slot")
	elif name_exists:
		set_error("A Slot with that name already exists")
	else:
		set_error()
	create_button.disabled = not name_is_valid


func _on_create_button_pressed() -> void:
	disable_inputs(true)
	var global_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if global_manager:
		await global_manager.create_resource(AWOCResourceType.Type.SLOT, name_line_edit.text, {})
	else:
		disable_inputs(false)


func _on_name_line_edit_text_changed(_new_text: String) -> void:
	validate()


func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.SLOT:
		modified_resource("New AWOC Created Successfully", result)
		

func _ready() -> void:
	create_button.disabled = true
	super._ready()
