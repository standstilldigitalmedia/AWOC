@tool
class_name AWOCMainEditorInterface
extends MarginContainer

@export var tab_label: Label
@export var welcome_tab: VBoxContainer
@export var tab_container: TabContainer
@export var preview_container: ScrollContainer
@export var details_container: ScrollContainer
@export var main_panel: PanelContainer
@export var preview_panel: PanelContainer
@export var details_panel: PanelContainer
@export var preview_placeholder: VBoxContainer
@export var details_placeholder: VBoxContainer

var preview_has_content: bool = false
var details_has_content: bool = false


func _ready() -> void:
	tab_container.hide()
	preview_container.hide()
	details_container.hide()

	# Initial state
	_update_visibility_state()

	var awoc_state: AWOCGlobalState = AWOCEditorGlobal.get_awoc_state()
	if awoc_state:
		awoc_state.awoc_loaded.connect(_on_awoc_loaded)

	# Connect to visibility signals
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.preview_content_changed.connect(_on_preview_content_changed)
		signal_bus.details_content_changed.connect(_on_details_content_changed)


func _on_awoc_loaded(awoc_name: String) -> void:
	tab_label.text = awoc_name
	welcome_tab.hide()
	tab_container.show()


func _on_home_button_pressed() -> void:
	tab_label.text = "Welcome"
	tab_container.hide()
	welcome_tab.show()


func _on_preview_content_changed(has_content: bool) -> void:
	preview_has_content = has_content
	_update_visibility_state()


func _on_details_content_changed(has_content: bool) -> void:
	details_has_content = has_content
	_update_visibility_state()


## Updates visibility of all right-side panels based on content state
func _update_visibility_state() -> void:
	# Update preview panel
	if preview_has_content:
		preview_container.show()
		preview_placeholder.hide()
	else:
		preview_container.hide()
		preview_placeholder.show()

	# Update details panel
	if details_has_content:
		details_container.show()
		details_placeholder.hide()
	else:
		details_container.hide()
		details_placeholder.show()
