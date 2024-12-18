@tool
class_name AWOCTabBarTab
extends AWOCControlBase

var _slot_tab: AWOCSlotTab
var _mesh_tab: AWOCMeshTab
var _color_tab: AWOCColorTab
var _tab_container: TabContainer
var _tab_panel_container: PanelContainer
var _awoc_reference: AWOCEditorResourceReference


func _init(awoc_reference: AWOCEditorResourceReference) -> void:
	_awoc_reference = awoc_reference
	super()
	
	
func _create_controls() -> void:
	set_transparent_panel_container()
	_tab_panel_container = create_simi_transparent_panel_container()
	_tab_container = TabContainer.new()
	_slot_tab = AWOCSlotTab.new(_awoc_reference)
	_mesh_tab = AWOCMeshTab.new(_awoc_reference)
	_color_tab = AWOCColorTab.new(_awoc_reference)
	
	
func _parent_controls() -> void:
	var inner_vbox = create_vbox(0)
	inner_vbox.add_child(_tab_container)
	inner_vbox.add_child(_tab_panel_container)
	var outer_vbox = create_vbox(10)
	outer_vbox.add_child(inner_vbox)
	_tab_container.add_child(_slot_tab)
	_tab_container.add_child(_mesh_tab)
	_tab_container.add_child(_color_tab)
	_tab_container.set_tab_title(0, "Slots")
	_tab_container.set_tab_title(1, "Meshes")
	_tab_container.set_tab_title(2, "Colors")
	add_child(outer_vbox)
	
	
func _set_listeners() -> void:
	_tab_container.tab_selected.connect(_on_tab_selected)


func _on_tab_selected(index: int) -> void:
	match index:
		0:
			_slot_tab.reset_tab()
		1:
			_mesh_tab.reset_tab()
		2:
			_color_tab.reset_tab()


func set_awoc_reference(awoc_reference: AWOCEditorResourceReference) -> void:
	_awoc_reference = awoc_reference
	
	
func reset_tab() -> void:
	_slot_tab.reset_tab()
	_tab_container.set_current_tab(0)
