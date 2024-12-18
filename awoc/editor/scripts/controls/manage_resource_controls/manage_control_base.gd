@tool
class_name AWOCManageControlBase
extends AWOCResourceControlBase

signal resource_renamed(old_name: String, new_name: String)
signal resource_deleted(name: String)
signal show(resource_name: String)
signal hide(resource_name: String)


var _resource_name: String
var _name_line_edit: LineEdit
var _controls_hbox: HBoxContainer
var _rename_button: Button
var _delete_button: Button
var _show_button: Button
var _hide_button: Button
var _sub_controls_panel_container: PanelContainer
var _sub_controls_panel_vbox: VBoxContainer
var _rename_confirmation_dialog: ConfirmationDialog
var _delete_confirmation_dialog: ConfirmationDialog


func _init(resource_name) -> void:
	_resource_name = resource_name
	set_simi_transparent_panel_container()
	super()
	_name_line_edit.text = resource_name
	
	
func _create_controls() -> void:
	_controls_hbox = create_hbox(5)
	_rename_button = create_rename_button()
	_delete_button = create_delete_button()
	_show_button = create_show_button()
	_hide_button = create_hide_button()
	_sub_controls_panel_container = create_simi_transparent_panel_container()
	_sub_controls_panel_container.visible = false
	_sub_controls_panel_vbox = create_vbox(5)
	_rename_confirmation_dialog = create_confirmation_dialog("","")
	_delete_confirmation_dialog = create_confirmation_dialog("","")
	
	
func _parent_controls() -> void:
	var outer_margin_container: MarginContainer = create_margin_container(5,5,5,5)
	var outer_vbox: VBoxContainer = create_vbox(0)
	var sub_controls_margin_container: MarginContainer = create_standard_margin_container()
	sub_controls_margin_container.add_child(_sub_controls_panel_vbox)
	_sub_controls_panel_container.add_child(sub_controls_margin_container)
	outer_vbox.add_child(_controls_hbox)
	outer_vbox.add_child(_sub_controls_panel_container)
	outer_margin_container.add_child(outer_vbox)
	outer_margin_container.add_child(_rename_confirmation_dialog)
	outer_margin_container.add_child(_delete_confirmation_dialog)
	add_child(outer_margin_container)
	

func _on_delete_button_pressed() -> void:
	_delete_confirmation_dialog.title = "Delete " + _resource_name + "?"
	_delete_confirmation_dialog.dialog_text = (
			"Are you sure you wish to delete " 
			+ _resource_name 
			+ "?")
	_delete_confirmation_dialog.visible = true
	
	
func _on_delete_confirmation_dialog_accepted() -> void:
	resource_deleted.emit(_resource_name)
	
		
func _set_listeners() -> void:
	_rename_confirmation_dialog.confirmed.connect(_on_rename_confirmation_dialog_accepted)
	_delete_confirmation_dialog.confirmed.connect(_on_delete_confirmation_dialog_accepted)
	_name_line_edit.text_changed.connect(_on_name_line_edit_text_change)
	

func _on_name_line_edit_text_change(new_text) -> void:
	validate_inputs()
	
	
func _on_rename_button_pressed() -> void:
	_rename_confirmation_dialog.title = "Rename " + _resource_name + "?"
	_rename_confirmation_dialog.dialog_text = (
			"Are you sure you wish to rename " 
			+ _resource_name 
			+ "?")
	_rename_confirmation_dialog.visible = true
	
	
func _on_show_button_pressed() -> void:
	_sub_controls_panel_container.visible = true
	_show_button.visible = false
	_hide_button.visible = true
	show.emit(_resource_name)
	
	
func _on_hide_button_pressed() -> void:
	_sub_controls_panel_container.visible = false
	_show_button.visible = true
	_hide_button.visible = false
	hide.emit(_resource_name)
	
	
func _on_rename_confirmation_dialog_accepted() -> void:
	resource_renamed.emit(_resource_name, _name_line_edit.text)
	
	
func create_confirmation_dialog(title: String, text: String) -> ConfirmationDialog:
	var confirmation_dialog: ConfirmationDialog = ConfirmationDialog.new()
	confirmation_dialog.title = title
	confirmation_dialog.dialog_text = text
	confirmation_dialog.set_initial_position(
			FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	confirmation_dialog.visible = false
	return confirmation_dialog
	
	
func create_delete_button() -> Button:
	var button = create_icon_button(AWOCGlobal.DELETE_ICON)
	button.pressed.connect(_on_delete_button_pressed)
	return button
	
			
func create_rename_button() -> Button:
	var button = create_icon_button(AWOCGlobal.RENAME_ICON)
	button.pressed.connect(_on_rename_button_pressed)
	return button


func create_show_button() -> Button:
	var button = create_icon_button(AWOCGlobal.SHOW_ICON)
	button.pressed.connect(_on_show_button_pressed)
	return button
	
			
func create_hide_button() -> Button:
	var button = create_icon_button(AWOCGlobal.HIDE_ICON)
	button.pressed.connect(_on_hide_button_pressed)
	button.visible = false
	return button
	
	
func validate_inputs() -> void:
	if !AWOCGlobal.is_valid_name(_name_line_edit.text):
		_rename_button.disabled = true
		return
	if _name_line_edit.text == _resource_name:
		_rename_button.disabled = true
		return
	_rename_button.disabled = false
