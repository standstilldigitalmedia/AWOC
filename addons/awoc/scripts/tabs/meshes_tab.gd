@tool
class_name AWOCMeshesTab extends AWOCTabBase

var awoc_resource_controller: AWOCResourceController

func _init(a_resource_controller: AWOCResourceController, preview: AWOCPreviewControl):
	awoc_resource_controller = a_resource_controller
	new_resource_control = AWOCNewMeshControl.new(awoc_resource_controller)
	manage_resources_control = AWOCManageMeshesControl.new(awoc_resource_controller, preview)
	super()
