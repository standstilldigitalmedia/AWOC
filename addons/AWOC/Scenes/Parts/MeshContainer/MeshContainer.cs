using Godot;

namespace AWOC
{
	[Tool]
	public partial class MeshContainer : VBoxContainer
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
