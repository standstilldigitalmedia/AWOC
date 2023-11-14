using Godot;

namespace AWOC
{
	[Tool]
	public partial class MeshesPane : CenterPaneBase
	{
		public override void InitPane(AWOCEditor awocEditor)
		{
			
		}
	}
}


/*@tool
extends AWOCBasePane

@export var mesh_object_file_path_label: Label
@export var load_mesh_dialog: FileDialog
@export var add_meshes_container: HBoxContainer
@export var mesh_container: PackedScene
@export var mesh_list_container: VBoxContainer
@export var mesh_list_background: ColorRect

var preview_mesh_list: Array

func show_mesh(mesh_name: String):
	preview_mesh_list.append(mesh_name)
	awoc_editor.preview_awoc_meshes(preview_mesh_list)

func hide_mesh(mesh_name: String):
	preview_mesh_list.erase(mesh_name)
	awoc_editor.preview_awoc_meshes(preview_mesh_list)
	
func populate_mesh_list_container():
	if awoc_editor != null:
		if awoc_editor.awoc_obj.source_avatar_file == null:
			add_meshes_container.visible = true
			mesh_list_background.visible = false
			return
			
		add_meshes_container.visible = false
		mesh_list_background.visible = true
		
		for child in mesh_list_container.get_children():
			child.queue_free()
		for mesh_name in awoc_editor.awoc_obj.source_mesh_list:
			var new_mesh_container = mesh_container.instantiate()
			new_mesh_container.hide_mesh.connect(hide_mesh)
			new_mesh_container.show_mesh.connect(show_mesh)
			mesh_list_container.add_child(new_mesh_container)
			new_mesh_container.set_mesh_name(mesh_name)
	
func _ready():
	populate_mesh_list_container()
	load_mesh_dialog.visible = false
	load_mesh_dialog.visible = false
	load_mesh_dialog.clear_filters()
	load_mesh_dialog.add_filter("*.glb", "GL Transmission Format Binary file")
	load_mesh_dialog.current_dir = "/"

func _on_mesh_object_file_path_button_pressed():
	load_mesh_dialog.visible = true

func _on_load_mesh_dialog_file_selected(path):
	mesh_object_file_path_label.set_text(path)
	awoc_editor.awoc_obj.init_source_avatar(path)
	awoc_editor.save_current_awoc()
	populate_mesh_list_container()*/