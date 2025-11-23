@tool
class_name AWOCNewMeshControl
extends AWOCNewResourceControlBase


@export var model_path_line_edit: LineEdit
@export var model_path_browse_button: Button
@export var add_mesh_button: Button
@export var file_dialog: FileDialog


func reset_inputs() -> void:
	model_path_line_edit.text = ""
	model_path_browse_button.disabled = false
	add_mesh_button.disabled = true
	
	
func disable_inputs(disable: bool) -> void:
	model_path_line_edit.editable = !disable
	model_path_browse_button.disabled = disable
	add_mesh_button.disabled = disable
	
	
func validate() -> void:
	var model_path_is_valid: bool = AWOCValidator.is_avatar_file(model_path_line_edit.text)
	var model_node_is_valid: bool = AWOCValidator.is_valid_node_path(model_path_line_edit.text)
	add_mesh_button.disabled = model_node_is_valid or model_node_is_valid
	"""var single_mesh_path_is_valid: bool = AWOCValidator
	create_button.disabled = not (name_is_valid and path_is_valid)"""


func _on_model_path_line_edit_text_changed(new_text: String) -> void:
	validate()


func _on_model_path_browse_button_pressed() -> void:
	file_dialog.show()
	

func _on_file_dialog_file_selected(path: String) -> void:
	model_path_line_edit.text = path
	validate()
	
	
func _on_add_meshes_button_pressed() -> void:
	SignalBus.create_new_resource_requested.emit(AWOCResourceType.Type.Mesh, "", {"path": model_path_line_edit.text}) 
	
	
func _ready() -> void:
	add_mesh_button.disabled = true
	set_error()
	file_dialog.add_filter("*.glb, *.gltf, *.fbx, *.obj, *.blend ; 3D Model Files")
	
		
"""@export var name_line_edit: LineEdit
@export var asset_path_line_edit: LineEdit
@export var browse_button: Button
@export var create_button: Button
@export var file_dialog: FileDialog


func validate() -> void:
	var name_is_valid = AWOCValidator.is_valid_name(name_line_edit.text)
	var path_is_valid = AWOCValidator.is_valid_directory_path(asset_path_line_edit.text)
	var name_exists = AWOCManager.has_named_resource(AWOCResourceType.Type.AWOC, name_line_edit.text)
	if not name_is_valid: 
		set_error("Please enter a valid name for your AWOC")
	elif name_exists:
		set_error("An AWOC with that name already exists")
	elif not path_is_valid: 
		set_error("Please enter a valid path for your AWOC")
	else: set_error() 
	create_button.disabled = not (name_is_valid and path_is_valid)


func reset_inputs() -> void:
	name_line_edit.text = ""
	asset_path_line_edit.text = ""
	create_button.disabled = true
	
	
func _on_create_button_pressed() -> void:
	var additional_data := {
		"path": asset_path_line_edit.text
	}
	SignalBus.create_new_resource_requested.emit(AWOCResourceType.Type.AWOC, name_line_edit.text, additional_data)
	reset_inputs()
	
	
func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate()
	
	
func _on_asset_path_line_edit_text_changed(new_text: String) -> void:
	validate()
	
	
func _on_browse_button_pressed() -> void:
	browse_button.disabled = true
	file_dialog.show()
	
	
func _on_file_dialog_dir_selected(dir: String) -> void:
	browse_button.disabled = false
	asset_path_line_edit.text = dir
	validate()


func _on_file_dialog_canceled() -> void:
	browse_button.disabled = false    


func _on_new_awoc_created(resource_type: AWOCResourceType.Type, result: String) -> void:
	if resource_type == AWOCResourceType.Type.AWOC:
		if result.is_empty():
			set_error("New AWOC Created Successfully")
			reset_inputs()
			await get_tree().create_timer(5.0).timeout
			set_error()
		else:
			set_error(result)
		

func _ready() -> void:
	set_error()
	create_button.disabled = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	SignalBus.resource_modified.connect(_on_new_awoc_created)"""
