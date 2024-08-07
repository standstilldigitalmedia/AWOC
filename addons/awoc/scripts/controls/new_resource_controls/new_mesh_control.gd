@tool
class_name AWOCNewMeshControl extends AWOCNewResourceControlBase

var avatar_path_line_edit: LineEdit
var avatar_browse_button: Button
var avatar_file_dialog: FileDialog
var single_mesh_path_line_edit: LineEdit
var create_resource_button: Button
var awoc_resource_controller: AWOCResourceControllerBase
var multiple_mesh_control_override_path: String = "res://addons/awoc/scripts/control_overrides/multiple_mesh_control_override.gd"
var single_mesh_control_override_path: String = "res://addons/awoc/scripts/control_overrides/single_mesh_control_override.gd"

func reset_inputs():
	avatar_path_line_edit.text = ""
	single_mesh_path_line_edit.text = ""
	create_resource_button.disabled = true
	if awoc_resource_controller.resource.meshes_uid_dictionary.size() > 0:
		single_mesh_path_line_edit.visible = true
		avatar_path_line_edit.visible = false
		avatar_browse_button.visible = false
	else:
		single_mesh_path_line_edit.visible = false
		avatar_path_line_edit.visible = true
		avatar_browse_button.visible = true

func validate_inputs() -> bool:
	if awoc_resource_controller.resource.meshes_uid_dictionary.size() > 0:
		if single_mesh_path_line_edit.text.is_absolute_path():
			create_resource_button.disabled = false
			return true
	else:
		if avatar_path_line_edit.text.is_absolute_path():
			create_resource_button.disabled = false
			return true
	create_resource_button.disabled = true
	return false
	
func _on_text_changed(new_text: String):
	validate_inputs()
	
func _on_browse_button_pressed():
	avatar_file_dialog.visible = true
	
func _on_add_new_resource_button_pressed():
	create_resource_button.disabled = true
	if validate_inputs():
		if awoc_resource_controller.resource.meshes_uid_dictionary.size() > 0:
			pass
		else:
			var avatar_file = load(avatar_path_line_edit.text)
			var avatar_obj: Node3D = avatar_file.instantiate()
			var skeleton_res: AWOCSkeleton = AWOCSkeleton.new()
			var skeleton: Skeleton3D = skeleton_res.recursive_get_skeleton(avatar_obj)
			if skeleton == null:
				for child in avatar_obj.get_children():
					printerr("child " + child.name)
			else:
				pass
				
			#awoc_res.avatar_res.serialize_avatar(avatar_obj,awoc_res.asset_creation_path)
		var new_slot = AWOCSlot.new()
		#new_slot.name = name_line_edit.text
		#var new_slot_resource_controller: AWOCDictionaryResourceController = AWOCDictionaryResourceController.new(new_slot,resource_controller.resource_controller,resource_controller.dictionary)
		#new_slot_resource_controller.create_resource()
		#hide_slot_tab.reset_tab()
		reset_inputs()
		resource_created.emit()
		
func _on_avatar_file_selected(path: String):
	avatar_path_line_edit.text = path
	validate_inputs()
		
func create_controls():
	main_panel_container = create_panel_container(0.0,0.0,0.0,0.0)
	avatar_path_line_edit = create_line_edit("Avatar Path")
	avatar_path_line_edit.text_changed.connect(_on_text_changed)
	avatar_path_line_edit.set_script(load(multiple_mesh_control_override_path))
	avatar_browse_button = create_browse_button()
	avatar_file_dialog = create_file_dialog("Avatar File")
	avatar_file_dialog.clear_filters()
	avatar_file_dialog.set_filters(PackedStringArray(["*.glb ; GL Transmission Format Binary"]))
	avatar_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	avatar_file_dialog.file_selected.connect(_on_avatar_file_selected)
	single_mesh_path_line_edit = create_line_edit("Single Mesh Path")
	single_mesh_path_line_edit.text_changed.connect(_on_text_changed)
	single_mesh_path_line_edit.set_script(load(single_mesh_control_override_path))
	create_resource_button = create_add_new_resource_button("Add Mesh(es)")
	create_resource_button.disabled = true
	
func parent_controls():
	var vbox: VBoxContainer = create_vbox(10)
	var hbox: HBoxContainer = create_hbox(10)
	hbox.add_child(avatar_path_line_edit)
	hbox.add_child(avatar_browse_button)
	vbox.add_child(hbox)
	vbox.add_child(single_mesh_path_line_edit)
	vbox.add_child(create_resource_button)
	vbox.add_child(avatar_file_dialog)
	main_panel_container.add_child(vbox)
	
func _init(a_controller: AWOCResourceControllerBase):
	awoc_resource_controller = a_controller
	create_controls()
	parent_controls()
	reset_inputs()
