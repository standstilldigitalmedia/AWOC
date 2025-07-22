@tool
class_name AWOCShowHideControlBase
extends AWOCResourceControlBase

signal show_control(res_name: String)
signal hide_control(res_name: String)

var show_button := AWOCShowIconButton.new()
var hide_button := AWOCHideIconButton.new()
var sub_controls_panel_container := AWOCPanelContainer.new(false)
var show_sub_controls: bool


func _init(p_text: String, r_name: String, s_sub_controls: bool) -> void:
	super(p_text, r_name)
	show_sub_controls = s_sub_controls
	

func create_controls(placeholder_text: String) -> void:
	super(placeholder_text)
	hide_button.hide()
	sub_controls_panel_container.hide()
	
	
func parent_controls() -> void:
	super()
	var test_label := AWOCLabel.new("Test label")
	var sub_controls_margin_container := AWOCMarginContainer.new(5,10,0,5)
	var sub_controls_vbox := AWOCVBox.new(5)
	controls_hbox.add_child(show_button)
	controls_hbox.add_child(hide_button)
	sub_controls_vbox.add_child(test_label)
	sub_controls_margin_container.add_child(sub_controls_vbox)
	sub_controls_panel_container.add_child(sub_controls_margin_container)
	add_child(sub_controls_panel_container)
	
	
func set_listeners() -> void:
	super()
	show_button.pressed.connect(_on_show_button_pressed)
	hide_button.pressed.connect(_on_hide_button_pressed)
	
	
func _on_show_button_pressed() -> void:
	show_button.hide()
	hide_button.show()
	if show_sub_controls:
		sub_controls_panel_container.show()
	show_control.emit(res_name)
	
	
func _on_hide_button_pressed() -> void:
	show_button.show()
	hide_button.hide()
	if show_sub_controls:
		sub_controls_panel_container.hide()
	hide_control.emit(res_name)
