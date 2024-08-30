@tool
class_name AWOCOverlaysTab extends AWOCTabBase

var overlays_dictionary: Dictionary

func _init(o_dictionary: Dictionary):
	overlays_dictionary = o_dictionary
	new_resource_control = AWOCNewOverlayControl.new(overlays_dictionary)
	manage_resources_control = AWOCManageOverlaysControl.new(overlays_dictionary)
	super()
