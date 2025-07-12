@tool
class_name AWOCTabContainer
extends TabContainer


func init_slot_tab(awoc: AWOCResource, awoc_uid: int) -> void:
	var slots_tab := AWOCSlotsTab.new(awoc, awoc_uid)
	var slots_margin_container := AWOCMarginContainer.new(10,0,10,0)
	slots_tab.reset_tab()
	slots_margin_container.add_child(slots_tab)
	add_child(slots_margin_container)
	set_tab_title(0, "Slots")
	
	
func init_mesh_tab(awoc: AWOCResource, awoc_uid: int) -> void:
	var mesh_tab := AWOCMeshTab.new(awoc, awoc_uid)
	var mesh_margin_container := AWOCMarginContainer.new(10,0,10,0)
	mesh_tab.reset_tab()
	mesh_margin_container.add_child(mesh_tab)
	add_child(mesh_margin_container)
	set_tab_title(1, "Meshes")


func _init(awoc: AWOCResource, awoc_uid: int) -> void:
	init_slot_tab(awoc, awoc_uid)
	init_mesh_tab(awoc, awoc_uid)
