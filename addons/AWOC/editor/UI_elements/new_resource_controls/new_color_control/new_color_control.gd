@tool
class_name AWOCNewColorControl
extends AWOCNewResourceControlBase

@export var name_line_edit: LineEdit
@export var color_picker_button: ColorPickerButton
@export var create_button: Button

func disable_inputs(disable: bool) -> void:
	name_line_edit.editable = !disable
	color_picker_button.disabled = disable


func reset_inputs() -> void:
	name_line_edit.text = ""
	create_button.disabled = true


func validate() -> void:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	var name_is_valid = AWOCValidator.is_valid_name(name_line_edit.text)
	var name_exists = awoc_manager.has_named_resource(AWOCResourceType.Type.COLOR, name_line_edit.text)
	if not name_is_valid:
		set_error("Please enter a valid name for your Color")
	elif name_exists:
		set_error("A Color with that name already exists")
	else:
		set_error()
	create_button.disabled = not name_is_valid


func _on_create_button_pressed() -> void:
	disable_inputs(true)
	var additional_data := {AWOCEditorGlobal.ADDITIONAL_DATA_COLOR: color_picker_button.color}
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if !signal_bus:
		disable_inputs(false)
		return
	signal_bus.create_new_resource_requested.emit(AWOCResourceType.Type.COLOR, name_line_edit.text, additional_data)


func _on_name_line_edit_text_changed(_new_text: String) -> void:
	validate()


func _on_new_slot_created(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.SLOT:
		if result.is_empty():
			set_error("New AWOC Created Successfully")
			reset_inputs()
			disable_inputs(false)
			if is_inside_tree():
				await get_tree().create_timer(5.0).timeout
				if is_inside_tree():
					set_error()
		else:
			set_error(result)
			disable_inputs(false)

func _on_resource_modified(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.SLOT:
		modified_resource("New AWOC Created Successfully", result)
		

func _on_color_picker_button_color_changed(color: Color) -> void:
	pass # Replace with function body.
	
	
func _ready() -> void:
	create_button.disabled = true
	super._ready()
