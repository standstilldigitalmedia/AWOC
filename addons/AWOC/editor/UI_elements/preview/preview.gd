@tool
class_name AWOCPreview
extends PanelContainer

@export var sub_viewport: SubViewport
@export var x_checkbox: CheckBox
@export var y_checkbox: CheckBox
@export var z_checkbox: CheckBox
@export var main_camera: Camera3D
@export var subject: Node3D
@export var move_speed_slider: HSlider
@export var zoom_speed_slider: HSlider
@export var rotate_speed_slider: HSlider

var direction: Vector3  = Vector3.ZERO
var rotate: int = 0
var move_speed: int = 5
var zoom_speed: int = 10
var rotate_speed: int = 3
var subject_rotation: Vector3
var camera_position: Vector3


func set_subject(sub: Node3D) -> void:
	subject = sub
	subject.position = Vector3(0.0,0.0,0.0)
	subject.rotation = subject_rotation
	sub_viewport.add_child(subject)


func _on_x_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		y_checkbox.set_pressed_no_signal(false)
		z_checkbox.set_pressed_no_signal(false)
	else:
		x_checkbox.set_pressed_no_signal(true)
	
		
func _on_y_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		x_checkbox.set_pressed_no_signal(false)
		z_checkbox.set_pressed_no_signal(false)
	else:
		y_checkbox.set_pressed_no_signal(true)
	
		
func _on_z_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		x_checkbox.set_pressed_no_signal(false)
		y_checkbox.set_pressed_no_signal(false)
	else:
		z_checkbox.set_pressed_no_signal(true)
	
		
func _process(delta) -> void:
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
	
	
func _on_button_up() -> void:
	direction = Vector3.ZERO
	rotate = 0

	
func _on_rotate_left_button_down() -> void:
	rotate = 1


func _on_up_button_down() -> void:
	direction.y = -1


func _on_rotate_right_button_down() -> void:
	rotate = -1


func _on_left_button_down() -> void:
	direction.x = 1


func _on_right_button_down() -> void:
	direction.x = -1


func _on_zoom_out_button_down() -> void:
	direction.z = 1


func _on_down_button_down() -> void:
	direction.y = 1


func _on_zoom_in_button_down() -> void:
	direction.z = -1


func _on_reset_button_pressed() -> void:
	main_camera.position = camera_position
	if subject != null:
		subject.rotation = Vector3.ZERO
	main_camera.size = 1


func _on_move_speed_h_slider_value_changed(value) -> void:
	move_speed = value


func _on_rotate_speed_h_slider_value_changed(value) -> void:
	rotate_speed = value


func _on_zoom_speed_h_slider_value_changed(value) -> void:
	zoom_speed = value
	
	
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
	camera_position = Vector3(0.0,0.0,30.0)
	subject_rotation = Vector3(0.0,0.0,0.0)
	main_camera.position = camera_position
	"""if subject != null:
		subject.queue_free()"""
		
		
func _ready() -> void:
	reset()
