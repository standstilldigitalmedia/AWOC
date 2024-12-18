@tool
class_name AWOCManageRecipesControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var dynamic_character: AWOCDynamicCharacter
var control_dictionary: Dictionary = {}

func _on_dynamic_color_update(recipe_name: String, overlay_name, new_color: Color):
	dynamic_character.update_dynamic_color(recipe_name, overlay_name,new_color)
	
func _on_shared_color_update(recipe_name: String, overlay_name, new_color: Color, color_name: String):
	if awoc_resource_controller.get_colors_dictionary().has(color_name):
		awoc_resource_controller.get_colors_dictionary()[color_name] = new_color
	dynamic_character.update_shared_color(color_name, new_color)
	for child in control_panel_container_vbox.get_children():
		child.reset_controls()

func reset_controls():
	control_dictionary = {}
	preview_control.visible = false
	preview_control.reset()
	if dynamic_character != null:
		dynamic_character.queue_free()
	super()

func _on_show_recipe(recipe_name: String):
	preview_control.visible = true
	if dynamic_character == null:
		dynamic_character = AWOCDynamicCharacter.new()
		dynamic_character.init_dynamic_character(awoc_resource_controller.awoc_resource)
		preview_control.set_subject(dynamic_character)
	dynamic_character.equip_recipe(recipe_name)
	var recipe: AWOCRecipe = awoc_resource_controller.get_recipe_by_name(recipe_name)
	if control_dictionary.has(recipe.slot_name):
		control_dictionary[recipe.slot_name].hide_button.visible = false
		control_dictionary[recipe.slot_name].show_button.visible = true
	for child in control_panel_container_vbox.get_children():
		if child.recipe_name == recipe_name:
			control_dictionary[recipe.slot_name] = child
		
	
func _on_hide_recipe(recipe_name: String):
	dynamic_character.unequip_recipe(recipe_name)
	var recipe: AWOCRecipe = awoc_resource_controller.get_recipe_by_name(recipe_name)
	if control_dictionary.has(recipe.slot_name):
		control_dictionary.erase(recipe.slot_name)
	if control_dictionary.size() < 1:
		preview_control.visible = false
		preview_control.reset()
		
func populate_resource_controls_area():
	super()
	for recipe_name in awoc_resource_controller.get_recipes_dictionary():
		var recipe_control = AWOCRecipeControl.new(awoc_resource_controller, recipe_name)
		recipe_control.controls_reset.connect(emit_controls_reset)
		recipe_control.show_recipe.connect(_on_show_recipe)
		recipe_control.hide_recipe.connect(_on_hide_recipe)
		recipe_control.dynamic_color_update.connect(_on_dynamic_color_update)
		recipe_control.shared_color_update.connect(_on_shared_color_update)
		control_panel_container_vbox.add_child(recipe_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Recipes")
	super()
	
func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	preview_control = preview
	super(awoc_resource_controller.get_recipes_dictionary())
