@tool
class_name AWOCTabBase extends AWOCControlBase

var main_margin_container: MarginContainer
var controls_vbox: VBoxContainer
var new_resource_vbox: VBoxContainer
var manage_resources_vbox: VBoxContainer
var new_resource_button: Button
var manage_resources_button: Button
var new_resource_panel_container: PanelContainer
var manage_resources_panel_container: PanelContainer
var new_resource_margin_container: MarginContainer
var manage_resources_margin_container: MarginContainer
var manage_resources_inner_vbox: VBoxContainer
var new_resource_control: AWOCNewResourceControlBase

func populate_manage_resources_container():
	for child in manage_resources_inner_vbox.get_children():
		child.queue_free()

func destroy_tab():
	if main_panel_container != null:
		main_panel_container.queue_free()

func create_tab_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	main_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin_container = create_margin_container(10,5,10,5)
	controls_vbox = create_vbox(10)
	new_resource_vbox = create_vbox(0)
	manage_resources_vbox = create_vbox(0)
	new_resource_button = Button.new()
	manage_resources_button = Button.new()
	new_resource_button.toggle_mode = true
	manage_resources_button.toggle_mode = true
	new_resource_panel_container = create_panel_container(1.0,1.0,1.0,0.05)
	manage_resources_panel_container = create_panel_container(1.0,1.0,1.0,0.05)
	new_resource_margin_container = create_margin_container(10,5,10,5)
	manage_resources_margin_container = create_margin_container(10,5,10,5)
	manage_resources_inner_vbox = create_vbox(10)
	
func set_tab_button_text(new_resource_button_text: String, manage_resources_button_text: String):
	new_resource_button.text = new_resource_button_text
	manage_resources_button.text = manage_resources_button_text
	
func parent_tab_controls():
	manage_resources_margin_container.add_child(manage_resources_inner_vbox)
	new_resource_panel_container.add_child(new_resource_margin_container)
	manage_resources_panel_container.add_child(manage_resources_margin_container)
	new_resource_vbox.add_child(new_resource_button)
	new_resource_vbox.add_child(new_resource_panel_container)
	manage_resources_vbox.add_child(manage_resources_button)
	manage_resources_vbox.add_child(manage_resources_panel_container)
	controls_vbox.add_child(new_resource_vbox)
	controls_vbox.add_child(manage_resources_vbox)
	main_margin_container.add_child(controls_vbox)
	main_panel_container.add_child(main_margin_container)

func on_new_resource_button_toggled(toggled_on: bool):
	if toggled_on:
		new_resource_panel_container.visible = true
		manage_resources_panel_container.visible = false
		manage_resources_button.set_pressed_no_signal(false)
	else:
		new_resource_panel_container.visible = false
		
func on_manage_resources_button_toggled(toggled_on: bool):
	if toggled_on:
		manage_resources_panel_container.visible = true
		new_resource_panel_container.visible = false
		new_resource_button.set_pressed_no_signal(false)
	else:
		manage_resources_panel_container.visible = false
	
func set_tab_listeners():
	new_resource_button.toggled.connect(on_new_resource_button_toggled)
	manage_resources_button.toggled.connect(on_manage_resources_button_toggled)
	
func set_manage_button_disabled():
	if  resource_controller.dictionary.size() > 0:
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		manage_resources_panel_container.visible = false
	
func reset_tab():
	new_resource_button.set_pressed_no_signal(false)
	manage_resources_button.set_pressed_no_signal(false)
	new_resource_panel_container.visible = false
	manage_resources_panel_container.visible = false
	set_manage_button_disabled()
	
func on_new_resource():	
	manage_resources_button.disabled = false
	new_resource_control.reset_inputs()
	populate_manage_resources_container()
	
func on_resource_renamed():
	populate_manage_resources_container()
	
func on_resource_deleted():
	populate_manage_resources_container()
	set_manage_button_disabled()
	
func create_new_resource_control():
	new_resource_control.resource_created.connect(on_new_resource)
	new_resource_margin_container.add_child(new_resource_control.main_panel_container)
	
func _init(r_controller: AWOCResourceControllerBase):
	super(r_controller)
	create_tab_controls()
	create_new_resource_control()
	populate_manage_resources_container()
	parent_tab_controls()
	set_tab_listeners()
	reset_tab()
