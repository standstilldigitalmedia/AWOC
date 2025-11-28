@tool
class_name AWOCEyeButton
extends Button


@export var open_eye: Texture2D
@export var closed_eye: Texture2D


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		icon = closed_eye
	else:
		icon = open_eye
