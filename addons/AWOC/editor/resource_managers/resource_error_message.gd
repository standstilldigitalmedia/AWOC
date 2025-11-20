@tool
class_name AWOCResourceErrorMessage
extends RefCounted

var resource: Resource = null
var error_message: String = ""

func has_resource() -> bool:
	if resource == null:
		return false
	return true
	

func has_error() -> bool:
	if error_message.is_empty():
		return false
	return true
	
	
func is_successful() -> bool:
	return !has_error()
	
	
func _init(res: Resource, e_message: String) -> void:
	resource = res
	error_message = e_message
