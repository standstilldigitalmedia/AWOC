@tool
class_name AWOCNewResourceControlBase extends AWOCControlBase

signal resource_created()

func reset_inputs():
	pass

func create_controls():
	main_panel_container = create_simi_transparent_panel_container()
	main_margin_container = create_margin_container(10,10,10,10)
	
func parent_controls():
	main_panel_container.add_child(main_margin_container)
	
func _on_add_new_resource_button_pressed():
		reset_inputs()
		resource_created.emit()
