@tool
class_name AWOCPreviewControl extends AWOCPreviewControlBase

var main_margin_contaier: MarginContainer
var main_vbox_container: VBoxContainer
var viewport_center_container: CenterContainer
var sub_viewport_container: SubViewportContainer
var sub_viewport: SubViewport
var main_camera: Camera3D
var directional_light: DirectionalLight3D
var controls_center_container: CenterContainer
var controls_hbox_container: HBoxContainer
var move_controls_vbox_container: VBoxContainer
var rotate_axis_vbox: VBoxContainer
var rotate_axis_checkbox_vbox: VBoxContainer
var move_controls_grid_container: GridContainer
var rotate_axis_hbox: HBoxContainer
var x_checkbox: CheckBox
var y_checkbox: CheckBox
var z_checkbox: CheckBox
var rotate_left_button: Button
var up_button: Button
var rotate_right_button: Button
var left_button: Button
var center_button: Button
var right_button: Button
var zoom_in_button: Button
var down_button: Button
var zoom_out_button: Button
var sliders_margin_container: MarginContainer
var sliders_vbox_container: VBoxContainer
var move_speed_slider: HSlider
var rotate_speed_slider: HSlider
var zoom_speed_slider: HSlider

var subject: Node3D
var direction: Vector3  = Vector3.ZERO
var rotate: int = 0
var move_speed: int = 5
var zoom_speed: int = 10
var rotate_speed: int = 3
var subject_rotation: Vector3
var camera_position: Vector3

func set_subject(sub: Node3D):
	subject = sub
	subject.position = Vector3(0.0,0.0,0.0)
	subject.rotation = subject_rotation
	sub_viewport.add_child(subject)

func _on_x_checkbox_toggled(toggled_on: bool):
	if toggled_on:
		y_checkbox.set_pressed_no_signal(false)
		z_checkbox.set_pressed_no_signal(false)
	else:
		x_checkbox.set_pressed_no_signal(true)
		
func _on_y_checkbox_toggled(toggled_on: bool):
	if toggled_on:
		x_checkbox.set_pressed_no_signal(false)
		z_checkbox.set_pressed_no_signal(false)
	else:
		y_checkbox.set_pressed_no_signal(true)
		
func _on_z_checkbox_toggled(toggled_on: bool):
	if toggled_on:
		x_checkbox.set_pressed_no_signal(false)
		y_checkbox.set_pressed_no_signal(false)
	else:
		z_checkbox.set_pressed_no_signal(true)
		
func _process(delta):
	if direction != Vector3.ZERO and subject != null:
		var new_position: Vector3 = main_camera.position
		if direction.x > 0:
			new_position.x = main_camera.position.x + (move_speed * delta)
		elif  direction.x < 0:
			new_position.x = main_camera.position.x - (move_speed * delta)
		if direction.y > 0:
			new_position.y = main_camera.position.y + (move_speed * delta)
		elif direction.y < 0:
			new_position.y = main_camera.position.y - (move_speed * delta)
		if direction.z > 0:
			new_position.z = main_camera.position.z + (zoom_speed * delta)
		elif direction.z < 0:
			new_position.z = main_camera.position.z -(zoom_speed * delta)
		main_camera.position = new_position;
		
	if rotate > 0:
		if x_checkbox.is_pressed():
			subject.rotate_x(rotate_speed * delta)
		if y_checkbox.is_pressed():
			subject.rotate_y(rotate_speed * delta)
		if z_checkbox.is_pressed():
			subject.rotate_z(rotate_speed * delta)
	elif rotate < 0:
		if x_checkbox.is_pressed():
			subject.rotate_x(-rotate_speed * delta)
		if y_checkbox.is_pressed():
			subject.rotate_y(-rotate_speed * delta)
		if z_checkbox.is_pressed():
			subject.rotate_z(-rotate_speed * delta)
	if rotate != 0:
		subject_rotation = subject.rotation
	
func _on_button_up():
	direction = Vector3.ZERO
	rotate = 0
	
func _on_rotate_left_button_down():
	rotate = 1

func _on_up_button_down():
	direction.y = -1

func _on_rotate_right_button_down():
	rotate = -1

func _on_left_button_down():
	direction.x = 1

func _on_right_button_down():
	direction.x = -1

func _on_zoom_out_button_down():
	direction.z = 1

func _on_down_button_down():
	direction.y = 1

func _on_zoom_in_button_down():
	direction.z = -1

func _on_reset_button_pressed():
	main_camera.position = camera_position
	if subject != null:
		subject.rotation = Vector3.ZERO
	main_camera.size = 1

func _on_move_speed_h_slider_value_changed(value):
	move_speed = value

func _on_rotate_speed_h_slider_value_changed(value):
	rotate_speed = value

func _on_zoom_speed_h_slider_value_changed(value):
	zoom_speed = value
		
func create_controls():
	main_margin_contaier = create_margin_container(0,0,0,0)
	viewport_center_container = CenterContainer.new()
	main_vbox_container = create_vbox(0)
	sub_viewport_container = create_sub_viewport_container()
	sub_viewport = create_sub_view_port()
	main_camera = create_camera(camera_position)
	directional_light = create_directional_light()
	controls_center_container = CenterContainer.new()
	controls_hbox_container = create_hbox(20)
	move_controls_vbox_container = create_vbox(0)
	rotate_axis_vbox = create_vbox(0)
	rotate_axis_checkbox_vbox = create_vbox(0)
	rotate_axis_hbox = create_hbox(0)
	x_checkbox = create_x_checkbox()
	y_checkbox = create_y_checkbox()
	z_checkbox = create_z_checkbox()
	move_controls_grid_container = create_grid_container()
	rotate_left_button = create_rotate_left_button()
	up_button = create_up_button()
	rotate_right_button = create_rotate_right_button()
	left_button = create_left_button()
	center_button = create_reset_button()
	right_button = create_right_button()
	zoom_in_button = create_zoom_in_button()
	down_button = create_down_button()
	zoom_out_button = create_zoom_out_button()
	sliders_margin_container = create_margin_container(0.0,0.0,0.0,0.0)
	sliders_vbox_container = create_vbox(5)
	move_speed_slider = create_move_speed_slider()
	rotate_speed_slider = create_rotate_speed_slider()
	zoom_speed_slider = create_zoom_speed_slider()
	
func parent_controls():
	sub_viewport.add_child(directional_light)
	sub_viewport.add_child(main_camera)
	sub_viewport_container.add_child(sub_viewport)
	
	rotate_axis_hbox.add_child(create_label("X"))
	rotate_axis_hbox.add_child(x_checkbox)
	rotate_axis_hbox.add_child(create_label("Y"))
	rotate_axis_hbox.add_child(y_checkbox)
	rotate_axis_hbox.add_child(create_label("Z"))
	rotate_axis_hbox.add_child(z_checkbox)
	
	rotate_axis_checkbox_vbox.add_child(create_label("Rotate Axis"))
	rotate_axis_checkbox_vbox.add_child(rotate_axis_hbox)
	
	move_controls_grid_container.add_child(rotate_left_button)
	move_controls_grid_container.add_child(up_button)
	move_controls_grid_container.add_child(rotate_right_button)
	move_controls_grid_container.add_child(left_button)
	move_controls_grid_container.add_child(center_button)
	move_controls_grid_container.add_child(right_button)
	move_controls_grid_container.add_child(zoom_in_button)
	move_controls_grid_container.add_child(down_button)
	move_controls_grid_container.add_child(zoom_out_button)
	
	rotate_axis_vbox.add_child(rotate_axis_checkbox_vbox)
	rotate_axis_vbox.add_child(move_controls_grid_container)
	
	sliders_vbox_container.add_child(create_label("Move Speed"))
	sliders_vbox_container.add_child(move_speed_slider)
	sliders_vbox_container.add_child(create_label("Rotate Speed"))
	sliders_vbox_container.add_child(rotate_speed_slider)
	sliders_vbox_container.add_child(create_label("Zoom Speed"))
	sliders_vbox_container.add_child(zoom_speed_slider)
	
	sliders_margin_container.add_child(sliders_vbox_container)
	
	controls_hbox_container.add_child(rotate_axis_vbox)
	controls_hbox_container.add_child(sliders_margin_container)
	
	viewport_center_container.add_child(sub_viewport_container)
	controls_center_container.add_child(controls_hbox_container)
	
	main_vbox_container.add_child(viewport_center_container)
	main_vbox_container.add_child(controls_center_container)
	main_margin_contaier.add_child(main_vbox_container)
	add_child(main_margin_contaier)
	
func set_panel_style():
	var panel_styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(0.0,0.0,0.0,0.0))
	add_theme_stylebox_override("panel", panel_styleBox)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	
func reset():
	x_checkbox.set_pressed_no_signal(true)
	y_checkbox.set_pressed_no_signal(false)
	z_checkbox.set_pressed_no_signal(false)
	move_speed = 5
	zoom_speed = 10
	rotate_speed = 3
	move_speed_slider.value = move_speed
	zoom_speed_slider.value = zoom_speed
	rotate_speed_slider.value = rotate_speed
	camera_position = Vector3(0.0,0.917,2.135)
	subject_rotation = Vector3(0.0,0.0,0.0)
	main_camera.position = camera_position
	if subject != null:
		subject.queue_free()
	
func _init():
	camera_position = Vector3(0.0,0.917,2.135)
	subject_rotation = Vector3(0.0,0.0,0.0)
	set_panel_style()
	super()
	
