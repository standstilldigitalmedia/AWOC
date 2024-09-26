@tool
class_name AWOCManageRecipesControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var dynamic_character: AWOCDynamicCharacter

func _on_show_recipe(recipe_name: String):
	preview_control.visible = true
	if dynamic_character == null:
		dynamic_character = AWOCDynamicCharacter.new()
		dynamic_character.init_dynamic_character(awoc_resource_controller.awoc_resource)
		preview_control.set_subject(dynamic_character)
	dynamic_character.equip_recipe(recipe_name)
	
func _on_hide_recipe(mesh_name: String):
	pass

func populate_resource_controls_area():
	super()
	for recipe_name in awoc_resource_controller.get_recipes_dictionary():
		var recipe_control = AWOCRecipeControl.new(awoc_resource_controller, recipe_name)
		recipe_control.controls_reset.connect(emit_controls_reset)
		recipe_control.show_recipe.connect(_on_show_recipe)
		recipe_control.hide_recipe.connect(_on_hide_recipe)
		control_panel_container_vbox.add_child(recipe_control)

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Recipes")
	super()
	
func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	preview_control = preview
	super(awoc_resource_controller.get_recipes_dictionary())
