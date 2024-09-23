@tool
class_name AWOCManageRecipesControl extends AWOCManageResourcesControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var recipe_list: Array

func _on_show_recipe(recipe_name: String):
	recipe_list.append(recipe_name)
	#preview_control.set_subject(awoc_resource_controller.instatiate_avatar_from_mesh_list(mesh_list))
	preview_control.visible = true
	
func _on_hide_recipe(mesh_name: String):
	recipe_list.erase(mesh_name)
	"""if mesh_list.size() < 1:
		preview_control.set_subject(null)
		preview_control.visible = false
	else:
		preview_control.set_subject(awoc_resource_controller.instatiate_avatar_from_mesh_list(mesh_list))"""

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
