@tool
class_name AWOCManageResourcesControlBase extends AWOCControlBase

signal resource_deleted()
signal resource_renamed()

var dictionary: Dictionary
var manage_resources_vbox: VBoxContainer

func on_resource_renamed():
	AWOCPlugin.scan()
	populate_manage_resources_container()
	resource_renamed.emit()
	
func on_resource_deleted():
	AWOCPlugin.scan()
	populate_manage_resources_container()
	resource_deleted.emit()
	
func create_controls():
	main_panel_container = create_simi_transparent_panel_container()
	main_margin_container = create_margin_container(10,10,10,10)
	manage_resources_vbox = create_vbox(10)
	
func parent_controls():
	main_panel_container.add_child(main_margin_container)
	main_margin_container.add_child(manage_resources_vbox)

func populate_manage_resources_container():
	for child in manage_resources_vbox.get_children():
		child.queue_free()
	
func _init(dict: Dictionary):
	dictionary = dict
	create_controls()
	parent_controls()
	populate_manage_resources_container()
