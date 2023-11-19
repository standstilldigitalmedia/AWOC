using Godot;

namespace AWOC
{
	[Tool]
	public partial class MaterialContainer : VBoxContainer
	{
		[Export] Button materialButton;
		[Export] HBoxContainer materialControlsContainer;
		[Export] ColorRect materialPropertiesContainer;
		[Export] LineEdit materialNameEdit;
		[Export] Button showButton;
		[Export] Button hideButton;
		[Export] ConfirmationDialog confirmSaveDialog;
		[Export] ConfirmationDialog confirmDeleteDialog;
		[Export] FileDialog albedoFileDialog;
		[Export] TextureRect albedoTextureRect;
		[Export] Label albedoLabel;
		[Export] string materialName;

		void InitImageDialog(FileDialog dialog)
		{
			dialog.Visible = false;
			dialog.ClearFilters();
			dialog.AddFilter("*.jpg", "Portable Network Graphic");
			dialog.CurrentDir = "/";
		}

		void SetMaterialName(string matName)
		{
			materialButton.Text = matName;
			materialName = matName;
			materialNameEdit.Text = matName;
			/*if awoc_editor != null and awoc_editor.awoc_obj != null and awoc_editor.awoc_obj.materials_dictionary != null:
				albedo_texture_rect.texture = awoc_editor.awoc_obj.materials_dictionary[material_name].albedo_texture
				albedo_label.visible = false*/
		}

		void _on_material_button_toggled(bool button_pressed)
		{
			materialControlsContainer.Visible = button_pressed;
			materialPropertiesContainer.Visible = false;
			showButton.Visible = true;
			hideButton.Visible = false;
		}

		void _on_save_button_pressed()
		{
			confirmSaveDialog.Title = "Rename " + materialName + "?";
			confirmSaveDialog.DialogText = "Are you sure you wish to rename " + materialName + "? This can not be undone.";
			confirmSaveDialog.Visible = true;
		}
		void _on_delete_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + materialName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + materialName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}

		void _on_show_button_pressed()
		{
			showButton.Visible = false;
			hideButton.Visible = true;
			materialPropertiesContainer.Visible = true;
		}

		void _on_hide_button_pressed()
		{
			showButton.Visible = true;
			hideButton.Visible = false;
			materialPropertiesContainer.Visible = false;
		}
	}
}


/*@tool
extends AWOCBasePane








	

	
func _on_confirm_save_dialog_confirmed():
	var new_name: String = material_name_edit.get_text()
	var new_material: AWOCMaterialRes = AWOCMaterialRes.new()
	awoc_editor.awoc_obj.materials_dictionary[new_name] = new_material
	new_material.material_name = new_name
	awoc_editor.awoc_obj.materials_dictionary.erase(material_name)
	set_material_name(new_name)
	awoc_editor.save_current_awoc()

func _on_confirm_delete_dialog_confirmed():
	awoc_editor.awoc_obj.materials_dictionary.erase(material_name)
	self.queue_free()


	
func _ready():
	confirm_save_dialog.visible = false
	confirm_delete_dialog.visible = false
	material_controls_container.visible = false
	material_properties_container.visible = false
	init_image_dialog(albedo_file_dialog)

func _on_albedo_file_button_pressed():
	albedo_file_dialog.visible = true

func _on_albedo_file_dialog_file_selected(path):
	albedo_label.visible = false
	var new_texture = load(path)
	albedo_texture_rect.texture = new_texture
	awoc_editor.awoc_obj.materials_dictionary[material_name].albedo_texture = new_texture
	awoc_editor.save_current_awoc()
	awoc_editor.preview_material(new_texture)*/
