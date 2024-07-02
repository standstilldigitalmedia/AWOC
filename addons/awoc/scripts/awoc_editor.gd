@tool
class_name AWOCEditor extends AWOCControlBase

var home_button: Button
var scroll_container: ScrollContainer
var scroll_panel_container: PanelContainer
var scroll_panel_vbox: VBoxContainer
var margin_container_vbox: VBoxContainer
var margin_container: MarginContainer
var awoc_manager_resource_controller: AWOCDiskResourceController
var selected_awoc_resource_controller: AWOCDiskResourceController

func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	home_button = Button.new()
	home_button.text = "AWOC"
	margin_container = create_margin_container(0,5,10,5)
	margin_container_vbox = create_vbox(0)
	scroll_container = create_scroll_container()
	scroll_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	scroll_panel_vbox = create_vbox(0)
	
func parent_controls(scroll: bool):
	margin_container.add_child(margin_container_vbox)
	scroll_panel_vbox.add_child(home_button)
	scroll_panel_vbox.add_child(margin_container)
	if scroll:
		scroll_panel_container.add_child(scroll_panel_vbox)
		scroll_container.add_child(scroll_panel_container)
		main_panel_container.add_child(scroll_container)
	else:
		main_panel_container.add_child(scroll_panel_vbox)
		
func show_tab_bar_tab():
	var tab_bar_tab: AWOCTabBarTab = AWOCTabBarTab.new(selected_awoc_resource_controller)
	for child in margin_container_vbox.get_children():
		child.queue_free()
	margin_container_vbox.add_child(tab_bar_tab.main_panel_container)
	
func on_awoc_edit(awoc: AWOCDiskResourceController):
	selected_awoc_resource_controller = awoc
	show_tab_bar_tab()
		
func show_welcome():
	var welcome_tab: AWOCWelcomeTab = AWOCWelcomeTab.new(awoc_manager_resource_controller)
	welcome_tab.set_tab_button_text("New AWOC", "Manage AWOCS")
	welcome_tab.awoc_edited.connect(on_awoc_edit)
	for child in margin_container_vbox.get_children():
		child.queue_free()
	margin_container_vbox.add_child(welcome_tab.main_panel_container)
	
func on_home_button_clicked():
	show_welcome()
	
func _init(awoc_manager_cr: AWOCDiskResourceController, scroll: bool):
	awoc_manager_resource_controller = awoc_manager_cr
	create_controls()
	parent_controls(scroll)
	home_button.pressed.connect(on_home_button_clicked)
	show_welcome()
