@tool
class_name AWOCEditor extends AWOCControlBase

var selected_awoc_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var scroll_container: ScrollContainer
var main_margin_container_vbox: VBoxContainer
var home_button: Button
var tab_panel_container: PanelContainer
var welcome_tab: AWOCWelcomeTab
var tab_bar_tab: AWOCTabBarTab

func create_controls():
	scroll_container = create_scroll_container()
	set_transparent_panel_container()
	main_margin_container_vbox = create_vbox(10)
	main_margin_container_vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	home_button = Button.new()
	home_button.text = "AWOC"
	welcome_tab = AWOCWelcomeTab.new()
	preview_control = AWOCPreviewControl.new()
	preview_control.visible = false
	
func parent_controls():
	var hbox: HBoxContainer = create_hbox(10)
	main_margin_container_vbox.add_child(home_button)
	main_margin_container_vbox.add_child(welcome_tab)
	scroll_container.add_child(main_margin_container_vbox)
	hbox.add_child(scroll_container)
	hbox.add_child(preview_control)
	add_child(hbox)
	#scroll_container.add_child(self)
	
func on_awoc_edited(awoc_resource_controller: AWOCResourceController):
	selected_awoc_controller = awoc_resource_controller
	show_tab_bar_tab()
	
func show_welcome():
	if tab_bar_tab != null:
		tab_bar_tab.visible = false
	welcome_tab.reset_tab()
	welcome_tab.visible = true
	preview_control.visible = false
	
func show_tab_bar_tab():
	tab_bar_tab = AWOCTabBarTab.new(selected_awoc_controller, preview_control)
	main_margin_container_vbox.add_child(tab_bar_tab)
	tab_bar_tab.reset_tab()
	tab_bar_tab.visible = true
	if welcome_tab != null:
		welcome_tab.visible = false
	
func on_home_button_clicked():
	show_welcome()
	
func set_editor_listeners():
	home_button.pressed.connect(on_home_button_clicked)
	welcome_tab.awoc_edited.connect(on_awoc_edited)
	
func _init():
	super()
	set_editor_listeners()
	show_welcome()
