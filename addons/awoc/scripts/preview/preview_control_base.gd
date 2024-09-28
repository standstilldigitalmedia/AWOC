@tool
class_name AWOCPreviewControlBase extends AWOCControlBase

func _on_button_up():
	pass
	
func _on_rotate_left_button_down():
	pass

func _on_up_button_down():
	pass

func _on_rotate_right_button_down():
	pass

func _on_left_button_down():
	pass

func _on_right_button_down():
	pass

func _on_zoom_out_button_down():
	pass

func _on_down_button_down():
	pass

func _on_zoom_in_button_down():
	pass

func _on_reset_button_pressed():
	pass

func _on_move_speed_h_slider_value_changed(value):
	pass

func _on_rotate_speed_h_slider_value_changed(value):
	pass

func _on_zoom_speed_h_slider_value_changed(value):
	pass
	
func _on_x_checkbox_toggled(toggled_on: bool):
	pass
		
func _on_y_checkbox_toggled(toggled_on: bool):
	pass
		
func _on_z_checkbox_toggled(toggled_on: bool):
	pass
	
func create_camera(camera_position: Vector3) -> Camera3D:
	var camera: Camera3D = Camera3D.new()
	camera.position = camera_position
	camera.rotation.x = 0.0
	camera.rotation.x = 0.0
	camera.rotation.x = 0.0
	return camera

func create_checkbox() -> CheckBox:
	var check_box: CheckBox = CheckBox.new()
	return check_box
	
func create_directional_light() -> DirectionalLight3D:
	var light: DirectionalLight3D = DirectionalLight3D.new()
	light.position.x = 0.0
	light.position.y = 3.996
	light.position.z = 5.392
	light.rotation.x = -36.9
	light.rotation.x = 0.0
	light.rotation.x = 0.0
	return light
	
func create_down_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "ArrowDown.svg")
	button.button_down.connect(_on_down_button_down)
	return button
	
func create_hslider() -> HSlider:
	var slider = HSlider.new()
	slider.min_value = 1
	slider.max_value = 20
	slider.custom_minimum_size.x = 100
	return slider
	
func create_left_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "ArrowLeft.svg")
	button.button_down.connect(_on_left_button_down)
	return button
	
func create_movement_button() -> Button:
	var button: Button = create_small_button()
	button.button_up.connect(_on_button_up)
	return button
	
func create_move_speed_slider() -> HSlider:
	var slider = create_hslider()
	slider.value_changed.connect(_on_move_speed_h_slider_value_changed)
	slider.value = 5
	return slider
	
func create_reset_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "CenterView.svg")
	button.button_down.connect(_on_reset_button_pressed)
	return button
	
func create_right_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "ArrowRight.svg")
	button.button_down.connect(_on_right_button_down)
	return button
	
func create_rotate_left_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "RotateLeft.svg")
	button.button_down.connect(_on_rotate_left_button_down)
	return button

func create_rotate_right_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "RotateRight.svg")
	button.button_down.connect(_on_rotate_right_button_down)
	return button
	
func create_rotate_speed_slider() -> HSlider:
	var slider = create_hslider()
	slider.value_changed.connect(_on_rotate_speed_h_slider_value_changed)
	slider.value = 3
	return slider
	
func create_sub_view_port() -> SubViewport:
	var view_port: SubViewport = SubViewport.new()
	view_port.size.x = 350
	view_port.size.y = 350
	view_port.own_world_3d = true
	return view_port
	
func create_sub_viewport_container() -> SubViewportContainer:
	var container: SubViewportContainer = SubViewportContainer.new()
	container.size.x = 350
	container.size.y = 350
	return container
	
func create_up_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "ArrowUp.svg")
	button.button_down.connect(_on_up_button_down)
	return button
	
func create_x_checkbox() -> CheckBox:
	var check_box = create_checkbox()
	check_box.toggled.connect(_on_x_checkbox_toggled)
	return check_box
	
func create_y_checkbox() -> CheckBox:
	var check_box = create_checkbox()
	check_box.toggled.connect(_on_y_checkbox_toggled)
	return check_box
	
func create_z_checkbox() -> CheckBox:
	var check_box = create_checkbox()
	check_box.toggled.connect(_on_z_checkbox_toggled)
	return check_box
	
func create_zoom_in_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "Add.svg")
	button.button_down.connect(_on_zoom_in_button_down)
	return button
	
func create_zoom_out_button() -> Button:
	var button: Button = create_movement_button()
	button.icon = preload(AWOCPlugin.IMAGE_BASE_DIR + "CurveConstant.svg")
	button.button_down.connect(_on_zoom_out_button_down)
	return button
	
func create_zoom_speed_slider() -> HSlider:
	var slider = create_hslider()
	slider.value_changed.connect(_on_zoom_speed_h_slider_value_changed)
	slider.value = 10
	return slider
