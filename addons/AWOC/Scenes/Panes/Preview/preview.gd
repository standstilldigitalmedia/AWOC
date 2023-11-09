@tool
extends AWOCBasePane

@export var viewport: SubViewport
@export var camera: Camera3D

var subject: Node3D

var direction = Vector3.ZERO
var rotate: int = 0
var move_speed: int = 5
var zoom_speed: int = 10
var rotate_speed: int = 3

var camera_position: Vector3
var subject_rotation: Vector3 = Vector3.ZERO

func set_new_subject(new_subject: Node3D):
	if subject != null:
		subject.queue_free()
	subject = new_subject
	viewport.add_child(new_subject)

func _ready():
	camera_position = camera.position

func _process(delta):
	if direction != Vector3.ZERO:
		if direction.x > 0:
			camera.position.x += move_speed * delta
		elif direction.x < 0:
			camera.position.x -= move_speed *delta
		elif direction.y > 0:
			camera.position.y += move_speed * delta
		elif direction.y < 0:
			camera.position.y -= move_speed * delta
		elif direction.z > 0:
			camera.position.z += zoom_speed * delta
		elif direction.z < 0:
			camera.position.z -= zoom_speed * delta
	if rotate > 0:
		subject.rotate_y(rotate_speed * delta)
	elif rotate < 0:
		subject.rotate_y(-rotate_speed * delta)

func on_button_up():
	direction = Vector3.ZERO
	rotate = 0

func _on_left_button_down():
	direction.x = 1

func _on_right_button_down():
	direction.x = -1

func _on_up_button_down():
	direction.y = -1

func _on_down_button_down():
	direction.y = 1

func _on_zoom_in_button_down():
	direction.z = -1

func _on_zoom_out_button_down():
	direction.z = 1

func _on_rotate_left_button_down():
	rotate = -1

func _on_rotate_right_button_down():
	rotate = 1

func _on_center_pressed():
	camera.position = camera_position
	subject.rotation = subject_rotation
