@tool
class_name AWOCControlBase
extends PanelContainer


#override
func _init() -> void:
	_create_controls()
	_parent_controls()
	_set_listeners()
	
	
func _create_controls() -> void:
	pass
	
	
func _parent_controls() -> void:
	pass
	
	
func _set_listeners() -> void:
	pass
	

#do not call directly from outside this class
func create_margin_container(top: int, left: int, bottom: int, right: int) -> MarginContainer:
	var margin_container: MarginContainer = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", top)
	margin_container.add_theme_constant_override("margin_left", left)
	margin_container.add_theme_constant_override("margin_bottom", bottom)
	margin_container.add_theme_constant_override("margin_right", right)
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	margin_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return margin_container
	
	
func create_panel_container(r: float, g: float, b: float, a: float) -> PanelContainer:
	var panel_container: PanelContainer = PanelContainer.new()
	var panel_styleBox: StyleBoxFlat = panel_container.get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	panel_container.add_theme_stylebox_override("panel", panel_styleBox)
	panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	panel_container.set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return panel_container
	

func set_panel_container(r: float, g: float, b: float, a: float) -> void:
	var panel_styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	panel_styleBox.set("bg_color", Color(r,g,b,a))
	add_theme_stylebox_override("panel", panel_styleBox)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	set_v_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
#end do not call directly


func create_centered_label(text: String) -> Label:
	var label: Label = create_label(text)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label
	

func create_grid_container() -> GridContainer:
	var container: GridContainer = GridContainer.new()
	container.columns = 3
	return container
	
	
func create_hbox(seperation: int) -> HBoxContainer:
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", seperation)
	return hbox
	

func create_label(text) -> Label:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	return label
	
	
func create_line_edit(placeholder: String, text: String = "") -> LineEdit:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	line_edit.text = text
	line_edit.placeholder_text = placeholder
	return line_edit
	

func create_multi_mesh_line_edit() -> LineEdit:
	var line_edit = create_line_edit("Avatar File", "")
	line_edit.set_script(load("res://addons/awoc/editor/scripts/control_overrides/multiple_mesh_control_override.gd"))
	return line_edit
	
			
func create_simi_transparent_panel_container() -> PanelContainer:
	return create_panel_container(1.0,1.0,1.0,0.05)		
	

func create_single_mesh_line_edit() -> LineEdit:
	var line_edit = create_line_edit("Single Mesh", "")
	line_edit.set_script(load("res://addons/awoc/editor/scripts/control_overrides/single_mesh_control_override.gd"))
	return line_edit
	
	
func create_standard_margin_container() -> MarginContainer:
	return create_margin_container(10,10,10,10)
	
		
func create_text_button(text: String) -> Button:
	var button = Button.new()
	button.text = text
	return button


func create_transparent_panel_container() -> PanelContainer:
	return create_panel_container(0,0,0,0)
	
		
func create_vbox(seperation: int) -> VBoxContainer:
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", seperation)
	return vbox
	
	
func set_simi_transparent_panel_container() -> void:
	set_panel_container(1.0,1.0,1.0,0.05)
	
	
func set_transparent_panel_container() -> void:
	set_panel_container(0.0,0.0,0.0,0.0)
