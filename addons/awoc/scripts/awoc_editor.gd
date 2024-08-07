@tool
class_name AWOCEditor extends AWOCControlBase

var home_button: Button
var tab_label: Label

var awoc_manager_resource_controller: AWOCResourceControllerBase
var selected_awoc_resource_controller: AWOCResourceControllerBase
var main_margin_container_vbox: VBoxContainer
var scroll_container: ScrollContainer
var tab_panel_container: PanelContainer

func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	home_button = Button.new()
	home_button.text = "AWOC"
	main_margin_container = create_margin_container(0,5,10,5)
	main_margin_container_vbox = create_vbox(10)
	scroll_container = create_scroll_container()
	tab_label = create_label("Welcome")
	
func parent_controls():
	main_margin_container_vbox.add_child(home_button)
	main_margin_container_vbox.add_child(tab_label)
	main_margin_container.add_child(main_margin_container_vbox)
	main_panel_container.add_child(main_margin_container)
	scroll_container.add_child(main_panel_container)
	
func on_awoc_edit(awoc: AWOCResourceControllerBase):
	selected_awoc_resource_controller = awoc
	show_tab_bar_tab()
	
func show_tab_bar_tab():
	var tab_bar_tab: AWOCTabBarTab = AWOCTabBarTab.new(selected_awoc_resource_controller)
	if tab_panel_container != null:
		tab_panel_container.queue_free()
	tab_panel_container = tab_bar_tab.main_panel_container
	main_margin_container_vbox.add_child(tab_panel_container)
	tab_label.text = selected_awoc_resource_controller.resource_name
		
func show_welcome():
	var welcome_tab: AWOCWelcomeTab = AWOCWelcomeTab.new(awoc_manager_resource_controller)
	welcome_tab.set_tab_button_text("New AWOC", "Manage AWOCS")
	welcome_tab.awoc_edited.connect(on_awoc_edit)
	if tab_panel_container != null:
		tab_panel_container.queue_free()
	tab_panel_container = welcome_tab.main_panel_container
	main_margin_container_vbox.add_child(tab_panel_container)
	tab_label.text = "Welcome"
	
func on_home_button_clicked():
	show_welcome()
	
func _init(awoc_manager_cr: AWOCResourceControllerBase, scroll: bool):
	awoc_manager_resource_controller = awoc_manager_cr
	create_controls()
	parent_controls()
	home_button.pressed.connect(on_home_button_clicked)
	show_welcome()
