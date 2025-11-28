@tool
class_name AWOCTabBase
extends VBoxContainer

@onready var new_resource_button: Button = $VBoxContainer/NewResourceButton
@onready var new_resource_panel_container: PanelContainer = $VBoxContainer/NewResourcePanelContainer
@onready var manage_resources_button: Button = $VBoxContainer2/ManageResourcesButton
@onready var manage_resource_panel_container: PanelContainer = $VBoxContainer2/ManageResourcesPanelContainer


func set_manage_button_type(resource_type: AWOCResourceType.Type) -> void:
	var awoc_manager: AWOCGlobalManager = AWOCEditorGlobal.get_awoc_manager()
	if !awoc_manager:
		return
	if awoc_manager.has_resources(resource_type):
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resource_panel_container.hide()
		
		
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
	set_manage_button_state()


func _on_awoc_resource_managers_ready() -> void:
	set_manage_button_state()


func _ready() -> void:
	new_resource_panel_container.hide()
	manage_resource_panel_container.hide()
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.resource_modified.connect(_on_resource_modified)
	var global_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if global_state:
		global_state.awoc_resource_managers_ready.connect(_on_awoc_resource_managers_ready)
