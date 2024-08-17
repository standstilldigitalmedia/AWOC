@tool
class_name AWOCEditor extends AWOCControlBase

var selected_awoc_controller: AWOCResourceController
var scroll_container: ScrollContainer
var main_margin_container_vbox: VBoxContainer
var home_button: Button
var tab_panel_container: PanelContainer
var welcome_tab: AWOCWelcomeTab
var tab_bar_tab: AWOCTabBarTab

func create_controls():
	scroll_container = create_scroll_container()
	main_panel_container = create_transparent_panel_container()
	main_margin_container_vbox = create_vbox(10)
	home_button = Button.new()
	home_button.text = "AWOC"
	welcome_tab = AWOCWelcomeTab.new()
	
func parent_controls():
	main_margin_container_vbox.add_child(home_button)
	main_margin_container_vbox.add_child(welcome_tab.main_panel_container)
	main_panel_container.add_child(main_margin_container_vbox)
	scroll_container.add_child(main_panel_container)
	
func on_awoc_edited(awoc_resource_controller: AWOCResourceController):
	selected_awoc_controller = awoc_resource_controller
	show_tab_bar_tab()
	
func show_welcome():
	if tab_bar_tab != null:
		tab_bar_tab.main_panel_container.visible = false
	welcome_tab.reset_tab()
	welcome_tab.main_panel_container.visible = true
	
func show_tab_bar_tab():
	if tab_bar_tab == null and selected_awoc_controller != null:
		tab_bar_tab = AWOCTabBarTab.new(selected_awoc_controller)
		main_margin_container_vbox.add_child(tab_bar_tab.main_panel_container)
	tab_bar_tab.reset_tab()
	tab_bar_tab.main_panel_container.visible = true
	if welcome_tab != null:
		welcome_tab.main_panel_container.visible = false
	
func on_home_button_clicked():
	show_welcome()
	
func set_editor_listeners():
	home_button.pressed.connect(on_home_button_clicked)
	welcome_tab.awoc_edited.connect(on_awoc_edited)
	
func _init():
	super()
	set_editor_listeners()
	show_welcome()
