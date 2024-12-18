@tool
class_name AWOCTabBase
extends AWOCControlBase


var _new_resource_button: Button
var _new_resource_panel_container: PanelContainer
var _manage_resources_button: Button
var _manage_resources_panel_container: PanelContainer
var _manage_resources_panel_vbox: VBoxContainer
var _new_resource_control: AWOCNewControlBase
var _resource_controller: AWOCControllerBase


func _init() -> void:
	super()
	set_transparent_panel_container()
	populate_manage_controls()
	set_manage_resources_button_disabled()
	
	
func _create_controls() -> void:
	_manage_resources_panel_vbox = create_vbox(5)
	_new_resource_panel_container = create_simi_transparent_panel_container()
	_manage_resources_panel_container = create_simi_transparent_panel_container()
	_new_resource_panel_container.visible = false
	_manage_resources_panel_container.visible = false
	

func _parent_controls() -> void:
	var outer_margin_container: MarginContainer = create_margin_container(5,0,0,0)
	var vbox = create_vbox(10)
	var new_resource_vbox = create_vbox(0)
	var manage_resources_vbox = create_vbox(0)
	var new_resource_margin_container: MarginContainer = create_standard_margin_container()
	var manage_resources_margin_container: MarginContainer = create_standard_margin_container()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	new_resource_margin_container.add_child(_new_resource_control)
	manage_resources_margin_container.add_child(_manage_resources_panel_vbox)
	_new_resource_panel_container.add_child(new_resource_margin_container)
	_manage_resources_panel_container.add_child(manage_resources_margin_container)
	new_resource_vbox.add_child(_new_resource_button)
	new_resource_vbox.add_child(_new_resource_panel_container)
	manage_resources_vbox.add_child(_manage_resources_button)
	manage_resources_vbox.add_child(_manage_resources_panel_container)
	vbox.add_child(new_resource_vbox)
	vbox.add_child(manage_resources_vbox)
	outer_margin_container.add_child(vbox)
	add_child(outer_margin_container)
	

func _set_listeners() -> void:
	_new_resource_button.toggled.connect(_on_new_resource_button_toggled)
	_manage_resources_button.toggled.connect(_on_manage_resources_button_toggled)
	

func _on_manage_resources_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_manage_resources_panel_container.visible = true
		_new_resource_panel_container.visible = false
		_new_resource_button.set_pressed_no_signal(false)
	else:
		_manage_resources_panel_container.visible = false
		
		
func _on_new_resource_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_new_resource_panel_container.visible = true
		_manage_resources_panel_container.visible = false
		_manage_resources_button.set_pressed_no_signal(false)
	else:
		_new_resource_panel_container.visible = false
		
		
func _on_resource_deleted(resource_name) -> void:
	_resource_controller.delete_res(resource_name)
	set_manage_resources_button_disabled()
	populate_manage_controls()
	
		
func _on_resource_renamed(old_name: String, new_name: String) -> void:
	_resource_controller.rename_res(old_name, new_name)
	populate_manage_controls()
	
	
func create_toggle_text_button(text: String) -> Button:
	var button = create_text_button(text)
	button.toggle_mode = true
	return button


func populate_manage_controls() -> void:
	for child in _manage_resources_panel_vbox.get_children():
		child.queue_free()
		

func reset_tab() -> void:
	_new_resource_control.reset_inputs()
	_new_resource_panel_container.visible = false
	_manage_resources_button.set_pressed_no_signal(false)
	_manage_resources_panel_container.visible = false
	_new_resource_button.set_pressed_no_signal(false)
	populate_manage_controls()
	set_manage_resources_button_disabled()
	
			
func add_manage_resource_control_and_set_listeners(resource_control: AWOCManageControlBase) -> void:
	resource_control.resource_renamed.connect(_on_resource_renamed)
	resource_control.resource_deleted.connect(_on_resource_deleted)
	_manage_resources_panel_vbox.add_child(resource_control)

	
func set_manage_resources_button_disabled() -> void:
	if _resource_controller._get_dictionary().size() > 0:
		_manage_resources_button.disabled = false
	else:
		_manage_resources_button.disabled = true
		_manage_resources_button.set_pressed_no_signal(false)
		_manage_resources_panel_container.visible = false
