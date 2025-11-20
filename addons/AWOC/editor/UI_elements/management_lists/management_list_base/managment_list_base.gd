@tool
class_name AWOCManagementListBase
extends VBoxContainer

@export var error_label: Label
@export var content_container: VBoxContainer

func clear_children() -> void:
	for child in content_container.get_children():
		child.queue_free()
		

func set_error(error_message: String = "") -> void:
	if not error_label:
		push_error("Error label must be assigned.")
		return
	if error_message.is_empty():
		error_label.hide()
	else:
		error_label.text = error_message
		error_label.show()
