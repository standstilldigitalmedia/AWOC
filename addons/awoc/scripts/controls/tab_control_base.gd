@tool
class_name AWOCTabControlBase extends AWOCControlBase

signal show_control()

var tab_button: Button
var control_panel_margin_container: MarginContainer
var control_panel_container: PanelContainer
var control_panel_container_vbox: VBoxContainer

func reset_controls():
	pass

func show_control_panel_container():
	control_panel_container.visible = true
	show_control.emit()

func hide_control_panel_container():
	control_panel_container.visible = false
	tab_button.set_pressed_no_signal(false)

func create_controls():
	set_transparent_panel_container()
	control_panel_container = create_simi_transparent_panel_container()
	control_panel_margin_container = create_margin_container(10,5,10,5)
	control_panel_container_vbox = create_vbox(10)
	
func parent_controls():
	control_panel_margin_container.add_child(control_panel_container_vbox)
	control_panel_container.add_child(control_panel_margin_container)
	var vbox = create_vbox(0)
	vbox.add_child(tab_button)
	vbox.add_child(control_panel_container)
	add_child(vbox)
	
func _init():
	super()
	hide_control_panel_container()
