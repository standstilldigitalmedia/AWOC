@tool
class_name AWOCMaterialsTab extends AWOCTabBase

var awoc_resource_controller: AWOCResourceController

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	new_resource_control = AWOCNewMaterialControl.new(awoc_resource_controller)
	manage_resources_control = AWOCManageMaterialsControl.new(awoc_resource_controller)
	super()
