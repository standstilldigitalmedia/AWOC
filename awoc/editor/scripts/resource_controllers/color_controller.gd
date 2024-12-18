@tool
class_name AWOCColorController
extends AWOCResourceControllerBase


func update_color(color_name: String, color: Color):
	get_reference(color_name).load_res().color = color
	get_reference(color_name).save_res()
	
	
func add_new_color(color_name: String, color: Color) -> void:
	if res_exists(color_name):
		printerr("A Color named " + color_name + " already exists.")
		return
	var reference: AWOCResourceReference = (
			AWOCResourceReference.new())
	var edior_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(reference)
	var awoc_color: AWOCColor = AWOCColor.new()
	awoc_color.color = color
	edior_reference.set_res(awoc_color)
	edior_reference.set_res_path(_awoc_reference.get_res_path().get_base_dir() + "/colors/" + color_name + ".res")
	edior_reference.save_res()
	_get_dictionary()[color_name] = reference
	_awoc_reference.save_res()
	scan()
	
	
func _get_dictionary() -> Dictionary[String, AWOCResourceReference]:
	return _awoc_reference.load_res().color_dictionary
