@tool
class_name AWOCTabBarTab extends AWOCControlBase

var tab_bar: TabBar
var tab_label: Label
var main_margin_container: MarginContainer
var main_vbox_container: VBoxContainer

func show_slots_tab():
	var slots_tab_controller: AWOCDictionaryResourceController = AWOCDictionaryResourceController.new(null, resource_controller.resource, resource_controller.resource.slots_uid_dictionary)
	var slots_tab: AWOCSlotsTab = AWOCSlotsTab.new(slots_tab_controller)
	slots_tab.set_tab_button_text("New Slot", "Manage Slots")
	slots_tab.reset_tab()
	main_vbox_container.add_child(slots_tab.main_panel_container)

func on_tab_changed(tab: int):
	for child in main_vbox_container.get_children():
		child.queue_free()
	match tab:
		0:
			show_slots_tab()

func set_tab_bar():
	tab_bar = TabBar.new()
	tab_bar.add_tab("Slots")
	tab_bar.add_tab("Meshes")
	tab_bar.add_tab("Materials")
	tab_bar.add_tab("Recipes")
	tab_bar.add_tab("Wardrobes")
	
func create_controls():
	set_tab_bar()
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	tab_label = create_label(resource_controller.resource.name)
	main_vbox_container = create_vbox(10)
	
func parent_controls():
	main_vbox_container.add_child(tab_label)
	main_vbox_container.add_child(tab_bar)
	main_panel_container.add_child(main_vbox_container)
	
func set_listeners():
	tab_bar.tab_changed.connect(on_tab_changed)
	
func _init(r_resource_controller: AWOCDiskResourceController):
	resource_controller = r_resource_controller
	create_controls()
	parent_controls()
	show_slots_tab()
