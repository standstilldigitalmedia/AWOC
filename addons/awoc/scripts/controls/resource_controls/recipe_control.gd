@tool
class_name AWOCRecipeControl extends AWOCResourceControlBase

signal show_recipe(recipe_name: String)
signal hide_recipe(recipe_name: String)
signal dynamic_color_update(recipe_name: String, overlay_name, new_color: Color)
signal shared_color_update(recipe_name: String, overlay_name, new_color: Color, color_name: String)

var awoc_resource_controller: AWOCResourceController
var recipe_name: String
var name_line_edit: LineEdit
var rename_button: Button
var delete_button: Button
var show_button: Button
var hide_button: Button
var controls_panel_container: PanelContainer
var controls_panel_vbox_container: VBoxContainer
var rename_confimation_dialog: ConfirmationDialog
var delete_confirmation_dialog: ConfirmationDialog
var color_button_hbox_array: Array[HBoxContainer]

func reset_controls():
	color_button_hbox_array = []
	create_color_picker_buttons()
	for child in controls_panel_vbox_container.get_children():
		child.queue_free()
	for color_button_hbox in color_button_hbox_array:
		controls_panel_vbox_container.add_child(color_button_hbox)

func _on_delete_confirmed():
	awoc_resource_controller.remove_recipe(recipe_name)
	controls_reset.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_recipe(recipe_name, name_line_edit.text)
	controls_reset.emit()
	
func _on_rename_button_pressed():
	rename_confimation_dialog.visible = true
	
func _on_delete_button_pressed():
	delete_confirmation_dialog.visible = true
	
func _on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	controls_panel_container.visible = true
	show_recipe.emit(recipe_name)
	
func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	controls_panel_container.visible = false
	hide_recipe.emit(recipe_name)
	
func _on_name_line_edit_text_changed(new_text: String):
	if is_valid_name(name_line_edit.text):
		rename_button.disabled = false
	else:
		rename_button.disabled = true
	
func _on_shared_color_changed(overlay_name: String, new_color: Color, shared_color_name: String):	
	shared_color_update.emit(recipe_name, overlay_name, new_color, shared_color_name)
	
func _on_dynamic_color_changed(overlay_name: String, new_color: Color, shared_color_name: String):
	var awoc_recipe: AWOCRecipe = awoc_resource_controller.get_recipe_by_name(recipe_name)
	var awoc_material: AWOCMaterial = awoc_resource_controller.get_material_by_name(awoc_recipe.material_name)
	if awoc_material.overlays_dictionary.has(overlay_name):
		awoc_material.overlays_dictionary[overlay_name].dynamic_color = new_color
	dynamic_color_update.emit(recipe_name, overlay_name, new_color)
		
func create_color_picker_buttons():
	var awoc_recipe: AWOCRecipe = awoc_resource_controller.get_recipe_by_name(recipe_name)
	var awoc_material: AWOCMaterial = awoc_resource_controller.get_material_by_name(awoc_recipe.material_name)
	for overlay in awoc_material.overlays_dictionary:
		var awoc_overlay: AWOCOverlay = awoc_material.overlays_dictionary[overlay]
		if awoc_overlay.shared_color != "":
			var color_picker: AWOCColorPickerButton = AWOCColorPickerButton.new(overlay,awoc_overlay.shared_color)
			color_picker.color_update.connect(_on_shared_color_changed)
			color_picker.color = awoc_resource_controller.get_colors_dictionary()[awoc_overlay.shared_color]
			var hbox: HBoxContainer = create_hbox(5)
			hbox.add_child(create_label("Shared Color:"))
			hbox.add_child(create_label(awoc_overlay.shared_color))
			var center_container: CenterContainer = CenterContainer.new()
			center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
			center_container.add_child(color_picker)
			hbox.add_child(center_container)
			color_button_hbox_array.append(hbox)
		elif awoc_overlay.dynamic_color != Color(0,0,0,0):
			var color_picker: AWOCColorPickerButton = AWOCColorPickerButton.new(overlay, "")
			color_picker.color_update.connect(_on_dynamic_color_changed)
			color_picker.color = awoc_overlay.dynamic_color
			var hbox: HBoxContainer = create_hbox(5)
			hbox.add_child(create_label("Overlay Color:"))
			hbox.add_child(create_label(overlay))
			var center_container: CenterContainer = CenterContainer.new()
			center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
			center_container.add_child(color_picker)
			hbox.add_child(center_container)
			color_button_hbox_array.append(hbox)
			
func create_controls():
	set_transparent_panel_container()
	name_line_edit = create_name_line_edit("Recipe Name", recipe_name)
	rename_button = create_rename_button()
	delete_button = create_delete_button()
	show_button = create_show_button()
	hide_button = create_hide_button()
	hide_button.visible = false
	controls_panel_container = create_panel_container(1,1,1,0.1)
	controls_panel_container.visible = false
	rename_confimation_dialog = create_rename_confirmation_dialog(recipe_name)
	delete_confirmation_dialog = create_delete_confirmation_dialog(recipe_name)
	create_color_picker_buttons()
	super()
	
func parent_controls():
	var main_vbox: VBoxContainer = create_vbox(0)
	var controls_panel_margin_container: MarginContainer = create_margin_container(10,5,10,5)
	controls_panel_vbox_container = create_vbox(5)
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(show_button)
	hbox.add_child(hide_button)
	hbox.add_child(rename_confimation_dialog)
	hbox.add_child(delete_confirmation_dialog)
	for color_button_hbox in color_button_hbox_array:
		controls_panel_vbox_container.add_child(color_button_hbox)
	controls_panel_margin_container.add_child(controls_panel_vbox_container)
	controls_panel_container.add_child(controls_panel_margin_container)
	main_vbox.add_child(hbox)
	main_vbox.add_child(controls_panel_container)
	add_child(main_vbox)
	super()

func _init(a_controller: AWOCResourceController, r_name: String):
	awoc_resource_controller = a_controller
	recipe_name = r_name
	super()
