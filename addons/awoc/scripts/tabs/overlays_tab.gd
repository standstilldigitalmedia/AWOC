@tool
class_name AWOCOverlaysTab extends AWOCTabBase

var overlays_dictionary: Dictionary

func _init(mat_name: String, o_dictionary: Dictionary, awoc_resource_controller: AWOCResourceController):
	overlays_dictionary = o_dictionary
	new_resource_control = AWOCNewOverlayControl.new(awoc_resource_controller, mat_name,overlays_dictionary)
	manage_resources_control = AWOCManageOverlaysControl.new(overlays_dictionary)
	super()
