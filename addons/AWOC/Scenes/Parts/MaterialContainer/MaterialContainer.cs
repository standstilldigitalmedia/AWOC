using Godot;
using System;

public partial class MaterialContainer : Node
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

@export var material_button: Button
@export var material_controls_container: HBoxContainer
@export var material_properties_container: ColorRect
@export var material_name_edit: LineEdit
@export var show_button: Button
@export var hide_button: Button
@export var confirm_save_dialog: ConfirmationDialog
@export var confirm_delete_dialog: ConfirmationDialog
@export var albedo_file_dialog: FileDialog
@export var albedo_texture_rect: TextureRect
@export var albedo_label: Label
@export var material_name: String

func init_image_dialog(dialog: FileDialog):
	dialog.visible = false
	dialog.clear_filters()
	dialog.add_filter("*.jpg", "Portable Network Graphic")
	dialog.current_dir = "/"

func set_material_name(mat_name: String):
	material_button.set_text(mat_name)
	material_name = mat_name
	material_name_edit.set_text(mat_name)
	if awoc_editor != null and awoc_editor.awoc_obj != null and awoc_editor.awoc_obj.materials_dictionary != null:
		albedo_texture_rect.texture = awoc_editor.awoc_obj.materials_dictionary[material_name].albedo_texture
		albedo_label.visible = false

func _on_material_button_toggled(button_pressed):
	material_controls_container.visible = button_pressed
	material_properties_container.visible = false
	show_button.visible = true
	hide_button.visible = false
	
func _on_save_button_pressed():
	confirm_save_dialog.title = "Rename " + material_name + "?"
	confirm_save_dialog.dialog_text = "Are you sure you wish to rename " + material_name + "? This can not be undone."
	confirm_save_dialog.visible = true

func _on_delete_button_pressed():
	confirm_delete_dialog.title = "Delete " + material_name + "?"
	confirm_delete_dialog.dialog_text = "Are you sure you wish to delete " + material_name + "? This can not be undone."
	confirm_delete_dialog.visible = true
	
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

func _on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	material_properties_container.visible = true

func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	material_properties_container.visible = false
	
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
