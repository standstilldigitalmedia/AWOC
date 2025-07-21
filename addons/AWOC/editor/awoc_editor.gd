@tool
class_name AWOCEditor
extends AWOCPanelContainer

var tab_label := AWOCLabel.new("Welcome")
var welcome_tab := AWOCWelcomeTab.new()
var tab_container: AWOCTabContainer
var panels_vbox := AWOCVBox.new(10)
var preview_scroll_container := AWOCScrollContainer.new()
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
	#preview_scroll_container.add_child(AWOCPreviewControl.new())
	preview_scroll_container.visible = false
	super(true)


func _on_home_button_pressed() -> void:
	welcome_tab.reset_tab()
	if tab_container != null:
		tab_container.visible = false
	welcome_tab.visible = true
	tab_label.text = "Welcome"
	
	
func _on_tab_changed(new_tab: int) -> void:
	match new_tab:
		0:
			pass
			#tab_container.init_slot_tab(selected_awoc, selected_awoc_uid)
		1:
			pass
			#tab_container.init_mesh_tab(selected_awoc, selected_awoc_uid)
			
			
	
func _on_awoc_edited(awoc_name: String, awoc: AWOCResource, awoc_uid: int) -> void:
	selected_awoc = awoc
	selected_awoc_uid = awoc_uid
	if tab_container != null:
		tab_container.queue_free()
	tab_label.text = awoc_name
	tab_container = AWOCTabContainer.new(awoc, awoc_uid)
	tab_container.tab_changed.connect(_on_tab_changed)
	panels_vbox.add_child(tab_container)
	welcome_tab.visible = false
	tab_container.visible = true
