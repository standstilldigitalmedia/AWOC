@tool
class_name AWOCNewRecipeControl extends AWOCNewResourceControlBase

var awoc_resource_controller: AWOCResourceController
var slots_option_button: OptionButton
var meshes_option_button: OptionButton
var materials_option_button: OptionButton
var name_line_edit: LineEdit
var default_checkbox: CheckBox
var create_new_resource_button: Button

func set_materials_option_button():
	if materials_option_button == null:
		materials_option_button = create_option_button()
	materials_option_button.clear()
	for material in awoc_resource_controller.get_materials_dictionary():
		materials_option_button.add_item(material)
	materials_option_button.selected = -1
	
func set_meshes_option_button():
	if meshes_option_button == null:
		meshes_option_button = create_option_button()
	meshes_option_button.clear()
	for mesh in awoc_resource_controller.get_meshes_dictionary():
		meshes_option_button.add_item(mesh)
	meshes_option_button.selected = -1
	
func set_slots_option_button():
	if slots_option_button == null:
		slots_option_button = create_option_button()
	slots_option_button.clear()
	for slot in awoc_resource_controller.get_slots_array():
		slots_option_button.add_item(slot.slot_name)
	slots_option_button.selected = -1

func reset_controls():
	create_new_resource_button.disabled = true
	name_line_edit.text = ""
	default_checkbox.set_pressed_no_signal(false)
	set_slots_option_button()
	set_meshes_option_button()
	set_materials_option_button()

func validate_inputs():
	if !is_valid_name(name_line_edit.text) or slots_option_button.selected < 0 or meshes_option_button.selected < 0 or materials_option_button.selected < 0:
		create_new_resource_button.disabled = true
		return
	create_new_resource_button.disabled = false
	
func _on_name_line_edit_text_changed(new_text: String):
	validate_inputs()
	
func _on_option_button_item_selected(index: int):
	validate_inputs()
	
func _on_add_new_resource_button_pressed():
	var new_recipe: AWOCRecipe = AWOCRecipe.new()
	new_recipe.slot_name = slots_option_button.get_item_text(slots_option_button.selected)
	new_recipe.mesh_name = meshes_option_button.get_item_text(meshes_option_button.selected)
	new_recipe.material_name = materials_option_button.get_item_text(materials_option_button.selected)
	if default_checkbox.button_pressed:
		new_recipe.default = true
	else:
		new_recipe.default = false
	awoc_resource_controller.add_new_recipe(name_line_edit.text, new_recipe)
	controls_reset.emit()

func create_controls():
	tab_button = create_new_resource_toggle_button("New Recipe")
	create_new_resource_button = create_add_new_resource_button("Create Recipe")
	name_line_edit = create_name_line_edit("Recipe Name")
	set_slots_option_button()
	set_meshes_option_button()
	set_materials_option_button()
	materials_option_button.item_selected.connect(_on_option_button_item_selected)
	meshes_option_button.item_selected.connect(_on_option_button_item_selected)
	slots_option_button.item_selected.connect(_on_option_button_item_selected)
	default_checkbox = CheckBox.new()
	super()
	
func parent_controls():
	super()
	var slots_hbox = create_hbox(5)
	slots_hbox.add_child(create_label("Slot:"))
	slots_hbox.add_child(slots_option_button)
	var meshes_hbox = create_hbox(5)
	meshes_hbox.add_child(create_label("Mesh:"))
	meshes_hbox.add_child(meshes_option_button)
	var materials_hbox = create_hbox(5)
	materials_hbox.add_child(create_label("Material:"))
	materials_hbox.add_child(materials_option_button)
	var default_hbox = create_hbox(5)
	var default_center_container = CenterContainer.new()
	default_center_container.set_h_size_flags(Control.SizeFlags.SIZE_EXPAND_FILL)
	default_center_container.add_child(default_checkbox)
	default_hbox.add_child(create_label("Default Recipe:"))
	default_hbox.add_child(default_center_container)
	control_panel_container_vbox.add_child(name_line_edit)
	control_panel_container_vbox.add_child(slots_hbox)
	control_panel_container_vbox.add_child(meshes_hbox)
	control_panel_container_vbox.add_child(materials_hbox)
	control_panel_container_vbox.add_child(default_hbox)
	control_panel_container_vbox.add_child(create_new_resource_button)

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	super()
