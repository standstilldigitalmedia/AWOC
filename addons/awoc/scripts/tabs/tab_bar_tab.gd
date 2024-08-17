@tool
class_name AWOCTabBarTab extends AWOCControlBase

var awoc_resource_controller: AWOCResourceController
var slots_tab: AWOCSlotsTab
var tab_label: Label
var tab_bar: TabContainer
var tab_panel_container: PanelContainer

func reset_tab():
	slots_tab.reset_tab()
	tab_bar.set_current_tab(0)

func create_controls():
	main_panel_container = create_transparent_panel_container()
	tab_panel_container = create_simi_transparent_panel_container()
	tab_label = create_label(awoc_resource_controller.awoc_resource.awoc_name)
	tab_bar = TabContainer.new()
	slots_tab = AWOCSlotsTab.new(awoc_resource_controller)
	tab_bar.add_child(slots_tab.main_panel_container)
	tab_bar.set_tab_title(0, "Slots")
	
func parent_controls():
	var inner_vbox = create_vbox(0)
	inner_vbox.add_child(tab_bar)
	inner_vbox.add_child(tab_panel_container)
	var outer_vbox = create_vbox(10)
	outer_vbox.add_child(tab_label)
	outer_vbox.add_child(inner_vbox)
	main_panel_container.add_child(outer_vbox)

func _init(ar_controller: AWOCResourceController):
	awoc_resource_controller = ar_controller
	super()
