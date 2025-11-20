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
		
		
func _on_resource_created(resource_type: AWOCResourceType.Type, resource_name: String, result: AWOCResourceErrorMessage) -> void:
	if result.is_successful():
		set_manage_button_state()
		
			
func _on_resource_deleted(resource_type: AWOCResourceType.Type, resource_name: String, success: bool, error: String) -> void:
	if success:
		set_manage_button_state()
		

func _ready() -> void:
	if get_script() == AWOCTabBase:
		return
	new_resource_panel_container.hide()
	manage_resource_panel_container.hide()
	SignalBus.resource_created.connect(_on_resource_created)
	SignalBus.resource_deleted.connect(_on_resource_deleted)
	set_manage_button_state()
