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
