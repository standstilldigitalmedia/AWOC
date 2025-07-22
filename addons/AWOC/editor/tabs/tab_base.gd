@tool
class_name AWOCTabBase
extends AWOCMarginContainer

var new_resource_button: AWOCToggleButton
var new_resource_panel_container := AWOCPanelContainer.new(false)
var new_resource_content_vbox := AWOCVBox.new(10)
var manage_resources_button: AWOCToggleButton
var manage_resources_panel_container := AWOCPanelContainer.new(false)
var manage_resources_content_vbox := AWOCVBox.new(10)
var resource_manager: AWOCEditorResourceManagerBase
var create_resource_button: AWOCButton


func reset_manage_resources_controls() -> void:
	pass
	
	
func reset_new_resource_controls() -> void:
	create_resource_button.disabled = true
	
	
func reset_tab_controls() -> void:
	new_resource_panel_container.visible = false
	manage_resources_panel_container.visible = false
	new_resource_button.set_pressed_no_signal(false)
	manage_resources_button.set_pressed_no_signal(false)
	set_manage_button_disabled()
	
	
func reset_tab() -> void:
	reset_manage_resources_controls()
	reset_new_resource_controls()
	reset_tab_controls()
	
	
func set_manage_button_disabled() -> void:
	if resource_manager.has_resources():
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		
		
func clear_manage_resources_area() -> void:
	for child in manage_resources_content_vbox.get_children():
		child.queue_free()
		
			
func create_controls(new_resource_button_text: String, manage_resources_button_text: String) -> void:
	new_resource_button = AWOCToggleButton.new(new_resource_button_text)
	manage_resources_button = AWOCToggleButton.new(manage_resources_button_text)
	

func parent_controls() -> void:
	#var main_scroll_container := AWOCScrollContainer.new()
	#var preview_scroll_container := AWOCScrollContainer.new()
	var main_margin_box := AWOCMarginContainer.new(0,10,0,10)
	var main_vbox := AWOCVBox.new(10)
	var new_resource_vbox := AWOCVBox.new(0)
	var manage_resources_vbox := AWOCVBox.new(0)
	var new_resource_margin_container := AWOCMarginContainer.new(10,10,10,10)
	var manage_resources_margin_container := AWOCMarginContainer.new(10,10,10,10)
	new_resource_margin_container.add_child(new_resource_content_vbox)
	manage_resources_margin_container.add_child(manage_resources_content_vbox)
	new_resource_panel_container.add_child(new_resource_margin_container)
	manage_resources_panel_container.add_child(manage_resources_margin_container)
	new_resource_vbox.add_child(new_resource_button)
	new_resource_vbox.add_child(new_resource_panel_container)
	manage_resources_vbox.add_child(manage_resources_button)
	manage_resources_vbox.add_child(manage_resources_panel_container)
	main_vbox.add_child(new_resource_vbox)
	main_vbox.add_child(manage_resources_vbox)
	main_margin_box.add_child(main_vbox)
	add_child(main_margin_box)
	
	
func set_control_listeners() -> void:
	new_resource_button.toggled.connect(_on_new_resource_button_toggled)
	manage_resources_button.toggled.connect(_on_manage_resources_button_toggled)
	create_resource_button.pressed.connect(_on_create_resource_button_pressed)
	
		
func _init(new_resource_button_text: String, manage_resources_button_text: String) -> void:
	create_controls(new_resource_button_text, manage_resources_button_text)
	parent_controls()
	set_control_listeners()
	

func _on_new_resource_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		new_resource_panel_container.visible = true
		manage_resources_panel_container.visible = false
		manage_resources_button.set_pressed_no_signal(false)
	else:
		new_resource_panel_container.visible = false
		
		
func _on_manage_resources_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		new_resource_panel_container.visible = false
		manage_resources_panel_container.visible = true
		new_resource_button.set_pressed_no_signal(false)
	else:
		manage_resources_panel_container.visible = false
		
		
func _on_resource_renamed(old_name: String, new_name: String) -> void:
	resource_manager.rename_resource(old_name, new_name)
	reset_manage_resources_controls()
	
	
func _on_resource_deleted(slot_name) -> void:
	resource_manager.delete_resource(slot_name)
	if !resource_manager.has_resources():
		reset_tab_controls()
		
		
func _on_create_resource_button_pressed() -> void:
	reset_new_resource_controls()
	reset_manage_resources_controls()
	set_manage_button_disabled()
