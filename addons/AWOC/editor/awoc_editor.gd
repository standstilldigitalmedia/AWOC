@tool
class_name AWOCEditor
extends AWOCPanelContainer

var tab_label := AWOCLabel.new("Welcome")
var welcome_tab := AWOCWelcomeTab.new()
var tab_container: AWOCTabContainer
var panels_vbox := AWOCVBox.new(10)
var preview_scroll_container := AWOCScrollContainer.new()
var preview_control := AWOCPreviewControl.new()
var selected_awoc: AWOCResource
var selected_awoc_uid: int


func _init() -> void:
	var main_scroll_container := AWOCScrollContainer.new()
	var main_hbox := AWOCHBox.new(5)
	var preview_vbox := AWOCVBox.new(10)
	var home_button := AWOCButton.new("A W O C")
	home_button.pressed.connect(_on_home_button_pressed)
	welcome_tab.awoc_edited.connect(_on_awoc_edited)
	panels_vbox.add_child(home_button)
	panels_vbox.add_child(tab_label)
	panels_vbox.add_child(welcome_tab)
	main_scroll_container.add_child(panels_vbox)
	preview_scroll_container.add_child(preview_vbox)
	main_hbox.add_child(main_scroll_container)
	main_hbox.add_child(preview_scroll_container)
	add_child(main_hbox)
	preview_vbox.add_child(preview_control)
	preview_scroll_container.hide()
	show_welcome()
	super(true)
	
	
func show_welcome() -> void:
	welcome_tab.reset_tab_controls()
	welcome_tab.reset_new_resource_controls()
	welcome_tab.reset_manage_resources_controls()
	if tab_container != null:
		tab_container.visible = false
	welcome_tab.visible = true
	tab_label.text = "Welcome"


func _on_home_button_pressed() -> void:
	show_welcome()
	
	
func _on_tab_changed(new_tab: int) -> void:
	preview_scroll_container.hide()
	match new_tab:
		0:
			tab_container.slots_tab.reset_tab()
		1:
			tab_container.mesh_tab.reset_tab()
			
			
func _on_awoc_edited(awoc_name: String, awoc: AWOCResource, awoc_uid: int) -> void:
	selected_awoc = awoc
	selected_awoc_uid = awoc_uid
	if tab_container != null:
		tab_container.queue_free()
	tab_label.text = awoc_name
	tab_container = AWOCTabContainer.new(awoc, awoc_uid, preview_scroll_container, preview_control)
	tab_container.tab_changed.connect(_on_tab_changed)
	tab_container.slots_tab.reset_tab_controls()
	tab_container.slots_tab.reset_new_resource_controls()
	tab_container.slots_tab.reset_manage_resources_controls()
	panels_vbox.add_child(tab_container)
	welcome_tab.visible = false
	tab_container.visible = true
