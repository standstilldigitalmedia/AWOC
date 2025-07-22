@tool
class_name AWOCTabContainer
extends TabContainer

var slots_tab: AWOCSlotsTab
var mesh_tab: AWOCMeshTab

func init_slot_tab(awoc: AWOCResource, awoc_uid: int) -> void:
	slots_tab = AWOCSlotsTab.new(awoc, awoc_uid)
	var slots_margin_container := AWOCMarginContainer.new(10,0,10,0)
	slots_margin_container.add_child(slots_tab)
	add_child(slots_margin_container)
	set_tab_title(0, "Slots")
	
	
func init_mesh_tab(awoc: AWOCResource, awoc_uid: int, p_container: AWOCScrollContainer, p_control: AWOCPreviewControl) -> void:
	mesh_tab = AWOCMeshTab.new(awoc, awoc_uid, p_container, p_control)
	var mesh_margin_container := AWOCMarginContainer.new(10,0,10,0)
	mesh_margin_container.add_child(mesh_tab)
	add_child(mesh_margin_container)
	set_tab_title(1, "Meshes")


func _init(awoc: AWOCResource, awoc_uid: int, p_container: AWOCScrollContainer, p_control: AWOCPreviewControl) -> void:
	init_slot_tab(awoc, awoc_uid)
	init_mesh_tab(awoc, awoc_uid, p_container, p_control)
