@tool
class_name AWOCTabBase
extends VBoxContainer

@onready var new_resource_button: Button = $VBoxContainer/NewResourceButton
@onready var new_resource_panel_container: PanelContainer = $VBoxContainer/NewResourcePanelContainer
@onready var manage_resources_button: Button = $VBoxContainer2/ManageResourcesButton
@onready var manage_resource_panel_container: PanelContainer = $VBoxContainer2/ManageResourcesPanelContainer


func set_manage_button_state() -> void:
	push_error("set_manage_button_state must be overridden in derived class")


func _on_new_resource_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		new_resource_panel_container.show()
		manage_resource_panel_container.hide()
		manage_resources_button.set_pressed_no_signal(false)
	else:
		new_resource_panel_container.hide()


func _on_manage_resource_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		manage_resource_panel_container.show()
		new_resource_panel_container.hide()
		new_resource_button.set_pressed_no_signal(false)
	else:
		manage_resource_panel_container.hide()


func _on_resource_modified(_resource_type: AWOCResourceType.Type, result: String) -> void:
	if result.is_empty():
		set_manage_button_state()


func _ready() -> void:
	new_resource_panel_container.hide()
	manage_resource_panel_container.hide()
	set_manage_button_state()
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.connect(_on_resource_modified)
