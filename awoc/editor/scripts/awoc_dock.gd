@tool
class_name AWOCDock
extends AWOCControlBase

var _preview_control: Button
var _home_button: Button
var _welcome_tab: AWOCWelcomeTab
var _tab_bar_tab: AWOCTabBarTab
var _tab_label: Label
var _tab_vbox_container: VBoxContainer


func _init() -> void:
	super()
	show_welcome()
	

func _create_controls() -> void:
	set_transparent_panel_container()
	_home_button = Button.new()
	_home_button.text = "AWOC"
	_welcome_tab = AWOCWelcomeTab.new()
	_preview_control = Button.new()
	_preview_control.visible = false
	_tab_label = create_centered_label("Welcome")
	
	
func _parent_controls() -> void:
	var scroll_container = create_scroll_container()
	var hbox: HBoxContainer = create_hbox(10)
	var vbox: VBoxContainer = create_vbox(10)
	vbox.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	var tab_margin_container: MarginContainer = create_standard_margin_container()
	_tab_vbox_container = create_vbox(10)
	_tab_vbox_container.add_child(_tab_label)
	_tab_vbox_container.add_child(_welcome_tab)
	tab_margin_container.add_child(_tab_vbox_container)
	vbox.add_child(_home_button)
	vbox.add_child(tab_margin_container)
	scroll_container.add_child(vbox)
	hbox.add_child(scroll_container)
	hbox.add_child(_preview_control)
	add_child(hbox)


func _set_listeners() -> void:
	_home_button.pressed.connect(_on_home_button_clicked)
	_welcome_tab.awoc_edited.connect(_on_awoc_edited)
	
	
func _on_awoc_edited(awoc_name: String, awoc_reference: AWOCEditorResourceReference) -> void:
	_tab_label.text = awoc_name
	show_tab_bar_tab(awoc_reference)	
	
		
func _on_home_button_clicked() -> void:
	show_welcome()
	

func create_scroll_container() -> ScrollContainer:
	var scroll_container: ScrollContainer = ScrollContainer.new()
	scroll_container.custom_minimum_size = Vector2(0,300)
	scroll_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	scroll_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return scroll_container
	
		
func show_tab_bar_tab(awoc_reference: AWOCEditorResourceReference) -> void:
	_tab_bar_tab = AWOCTabBarTab.new(awoc_reference)
	_tab_bar_tab.visible = true
	_welcome_tab.visible = false
	_preview_control.visible = false
	_tab_vbox_container.add_child(_tab_bar_tab)
	
	
func show_welcome() -> void:
	_welcome_tab.reset_tab()
	if _tab_bar_tab != null:
		_tab_bar_tab.queue_free()
	_welcome_tab.visible = true
	_preview_control.visible = false
	_tab_label.text = "Welcome"
