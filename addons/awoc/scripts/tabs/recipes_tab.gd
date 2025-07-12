@tool
class_name AWOCRecipesTab extends AWOCTabBase

var awoc_resource_controller: AWOCResourceController

func reset_tab():
	new_resource_control.reset_controls()
	manage_resources_control.reset_controls()

func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	new_resource_control = AWOCNewRecipeControl.new(awoc_resource_controller)
	manage_resources_control = AWOCManageRecipesControl.new(awoc_resource_controller, preview)
	super()
