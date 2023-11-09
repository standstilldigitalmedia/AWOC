@tool
extends AWOCBasePane

@export var mesh_label: Label
@export var hide_button: Button
@export var show_button: Button

func set_mesh_name(mesh_name: String):
	mesh_label.set_text(mesh_name)
