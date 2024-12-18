@tool
class_name AWOCPreviewControl 
extends AWOCPreviewControlBase


var sub_viewport: SubViewport
var main_camera: Camera3D
var directional_light: DirectionalLight3D
var rotate_axis_checkbox_vbox: VBoxContainer
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
	sub_viewport = create_sub_view_port()
	main_camera = create_camera(camera_position)
	directional_light = create_directional_light()
	rotate_axis_checkbox_vbox = create_vbox(0)
	x_checkbox = create_x_checkbox()
	y_checkbox = create_y_checkbox()
	z_checkbox = create_z_checkbox()
	rotate_left_button = create_rotate_left_button()
	up_button = create_up_button()
	rotate_right_button = create_rotate_right_button()
	left_button = create_left_button()
	center_button = create_reset_button()
	right_button = create_right_button()
	zoom_in_button = create_zoom_in_button()
	down_button = create_down_button()
	zoom_out_button = create_zoom_out_button()
	move_speed_slider = create_move_speed_slider()
	rotate_speed_slider = create_rotate_speed_slider()
	zoom_speed_slider = create_zoom_speed_slider()
	
	
func parent_controls():
	var main_margin_contaier: MarginContainer = create_margin_container(0,0,0,0)
	var viewport_center_container: CenterContainer = CenterContainer.new()
	var main_vbox_container: VBoxContainer = create_vbox(0)
	var sub_viewport_container: SubViewportContainer = create_sub_viewport_container()
	var controls_center_container: CenterContainer = CenterContainer.new()
	var controls_hbox_container: HBoxContainer = create_hbox(20)
	var move_controls_vbox_container: VBoxContainer = create_vbox(0)
	var rotate_axis_vbox: VBoxContainer = create_vbox(0)
	var rotate_axis_hbox: HBoxContainer = create_hbox(0)
	var move_controls_grid_container: GridContainer = create_grid_container()
	var sliders_margin_container: MarginContainer = create_margin_container(0.0,0.0,0.0,0.0)
	var sliders_vbox_container: VBoxContainer = create_vbox(5)
	
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
	set_transparent_panel_container()
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
