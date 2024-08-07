@tool
class_name AWOCTabBarTab extends AWOCControlBase

var tab_bar: TabBar
var main_vbox_container: VBoxContainer
var inner_vbox_container: VBoxContainer
var awoc_resource_controller: AWOCResourceControllerBase

func show_avatar_tab():
	var avatar_tab: AWOCAvatarTab = AWOCAvatarTab.new(awoc_resource_controller)
	avatar_tab.set_tab_button_text("New Mesh(es)", "Manage Meshes")
	avatar_tab.reset_tab()
	inner_vbox_container.add_child(avatar_tab.main_panel_container)

func show_slots_tab():
	var slots_tab: AWOCSlotsTab = AWOCSlotsTab.new(awoc_resource_controller)
	slots_tab.set_tab_button_text("New Slot", "Manage Slots")
	slots_tab.reset_tab()
	inner_vbox_container.add_child(slots_tab.main_panel_container)

func on_tab_changed(tab: int):
	for child in inner_vbox_container.get_children():
		child.queue_free()
	match tab:
		0:
			show_slots_tab()
		1:
			show_avatar_tab()

func set_tab_bar():
	tab_bar = TabBar.new()
	tab_bar.add_tab("Slots")
	tab_bar.add_tab("Avatar")
	tab_bar.add_tab("Materials")
	tab_bar.add_tab("Recipes")
	tab_bar.add_tab("Wardrobes")
	
func create_controls():
	set_tab_bar()
	main_panel_container = create_transparent_panel_container()
	main_vbox_container = create_vbox(10)
	inner_vbox_container = create_vbox(0)
	
func parent_controls():
	main_vbox_container.add_child(tab_bar)
	main_vbox_container.add_child(inner_vbox_container)
	main_panel_container.add_child(main_vbox_container)
	
func set_listeners():
	tab_bar.tab_changed.connect(on_tab_changed)
	
func _init(a_controller: AWOCResourceControllerBase):
	awoc_resource_controller = a_controller
	create_controls()
	parent_controls()
	show_slots_tab()
	set_listeners()
