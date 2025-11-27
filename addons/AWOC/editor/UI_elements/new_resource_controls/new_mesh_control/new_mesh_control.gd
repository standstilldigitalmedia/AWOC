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


func _on_model_path_line_edit_text_changed(_new_text: String) -> void:
	validate()


func _on_model_path_browse_button_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	model_path_line_edit.text = path
	validate()


func _on_add_meshes_button_pressed() -> void:
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.create_new_resource_requested.emit(AWOCResourceType.Type.MESH, "", {"path": model_path_line_edit.text})


func _ready() -> void:
	add_mesh_button.disabled = true
	set_error()
	file_dialog.add_filter("*.glb, *.gltf, *.fbx, *.obj, *.blend ; 3D Model Files")
