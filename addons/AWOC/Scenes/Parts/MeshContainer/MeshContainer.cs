using Godot;
using System;

public partial class MeshContainer : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}

/*@tool
extends AWOCBasePane

signal hide_mesh(m_name)
signal show_mesh(m_name)

@export var mesh_label: Label
@export var hide_button: Button
@export var show_button: Button
@export var mesh_name: String

func set_mesh_name(m_name: String):
	mesh_name = m_name
	mesh_label.set_text(m_name)
	
func _on_hide_button_pressed():
	hide_button.visible = false
	show_button.visible = true
	hide_mesh.emit(mesh_name)

func _on_show_button_pressed():
	hide_button.visible = true
	show_button.visible = false
	show_mesh.emit(mesh_name)
*/
