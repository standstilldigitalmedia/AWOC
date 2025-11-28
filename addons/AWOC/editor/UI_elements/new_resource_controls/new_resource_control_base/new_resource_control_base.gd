@tool
class_name AWOCNewResourceControlBase
extends VBoxContainer

@export var error_label: Label


func set_error(error_message: String = "") -> void:
	if not error_label:
		push_error("Error label must be assigned.")
		return
	if error_message.is_empty():
		error_label.hide()
	else:
		error_label.text = error_message
		error_label.show()


func validate() -> void:
	push_error("validate() must be overriden in derived class.")


func reset_inputs() -> void:
	push_error("reset_inputs() must be overriden in derived class.")
	
	
func disable_inputs(disable: bool) -> void:
	push_error("disable_inputs() must be overriden in derived class.")
	
	
func modified_resource(success_message: String, result: String) -> void:
	if result.is_empty():
			set_error(success_message)
			reset_inputs()
			if is_inside_tree():
				await get_tree().create_timer(2.0).timeout
				if is_inside_tree():
					set_error()
	else:
		set_error(result)
	disable_inputs(false)
	
	
func _on_resource_modified(res_type: AWOCResourceType.Type, result: String) -> void:
	printerr("_on_resource_modified must be overridden in derived class")
			
			
func _ready() -> void:
	if error_label.text.is_empty():
		set_error()
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.connect(_on_resource_modified)
