using Godot;

namespace AWOC
{
	[Tool]
	public partial class MaterialsPane : CenterPaneBase
	{
		public override void InitPane(AWOCEditor awocEditor)
		{
			
		}
	}
}


/*@tool
extends AWOCBasePane

@export var new_material_name_edit: LineEdit
@export var materials_main_container: VBoxContainer
@export var material_container: PackedScene

func populate_materials_container():
	for child in materials_main_container.get_children():
		child.queue_free()
	if awoc_editor!= null and awoc_editor.awoc_obj != null:
		for material in awoc_editor.awoc_obj.materials_dictionary:
			var new_material_container = material_container.instantiate()
			new_material_container.awoc_editor = awoc_editor
			new_material_container.set_material_name(material)
			materials_main_container.add_child(new_material_container)

func _ready():
	populate_materials_container()
	
func _on_add_material_button_pressed():
	var new_material_name = new_material_name_edit.get_text()
	if new_material_name != null and new_material_name.length() > 3 and awoc_editor.awoc_obj != null:
		var new_material: AWOCMaterialRes = AWOCMaterialRes.new()
		new_material_name_edit.set_text("")
		new_material.material_name = new_material_name
		awoc_editor.awoc_obj.materials_dictionary[new_material_name] = new_material
		awoc_editor.save_current_awoc()
		populate_materials_container()*/
