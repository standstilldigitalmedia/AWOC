@tool
class_name AWOCMainEditorInterface
extends HBoxContainer

@export var tab_label: Label
@export var welcome_tab: VBoxContainer
@export var tab_container: TabContainer
@export var preview_container: ScrollContainer


func _on_awoc_loaded(awoc_name: String) -> void:
	tab_label.text = awoc_name
	welcome_tab.hide()
	tab_container.show()


func _ready() -> void:
	tab_container.hide()
	preview_container.hide()
	AWOCState.awoc_loaded.connect(_on_awoc_loaded)


func _on_home_button_pressed() -> void:
	tab_label.text = "Welcome"
	tab_container.hide()
	welcome_tab.show()
