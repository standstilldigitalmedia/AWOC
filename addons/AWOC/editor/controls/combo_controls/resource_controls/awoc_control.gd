@tool
class_name AWOCControl
extends AWOCResourceControlBase

signal edit(awoc_name: String)

var edit_button := AWOCEditIconButton.new()

	
func parent_controls() -> void:
	super()
	controls_hbox.add_child(edit_button)
	
	
func set_listeners() -> void:
	super()
	edit_button.pressed.connect(_on_edit_button_pressed)
	
	
func _on_edit_button_pressed() -> void:
	edit.emit(res_name)
	
