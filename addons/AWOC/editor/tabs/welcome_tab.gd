@tool
class_name AWOCWelcomeTab
extends AWOCTabBase

signal awoc_edited(awoc_name: String, awoc: AWOCResource, awoc_uid: int)

var name_line_edit := AWOCLineEdit.new("AWOC Name")
var path_editor := AWOCPathEditor.new("Asset Creation Path")

	
func reset_controls() -> void:
	name_line_edit.text = ""
	path_editor.reset_controls()
	super()
		
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(name_line_edit)
	new_resource_content_vbox.add_child(path_editor)
	new_resource_content_vbox.add_child(create_resource_button)
	
	
func set_control_listeners() -> void:
	super()
	path_editor.validated.connect(_on_path_editor_validated)
	name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	
		
func populate_manage_resources() -> void:
	clear_manage_resources_area()
	for awoc_name in resource_manager.get_sorted_name_array():
		var control := AWOCControl.new("AWOC Name", awoc_name)
		control.rename.connect(_on_resource_renamed)
		control.delete.connect(_on_resource_deleted)
		control.edit.connect(_on_awoc_edited)
		manage_resources_content_vbox.add_child(control)
		

func _init() -> void:
	resource_manager = AWOCEditorWelcomeResourceManager.new().load_welcome_resource_manager()
	create_resource_button = AWOCButton.new("Create AWOC")
	super("New AWOC", "Manage AWOCs")
	
			
func _on_path_editor_validated(validated: bool) -> void:
	if validated:
		if AWOCGlobal.is_valid_name(name_line_edit.text):
			create_resource_button.disabled = false
			return
	create_resource_button.disabled = true
		
		
func _on_name_line_edit_text_changed(new_text: String) -> void:
	path_editor.validate()
	
	
func _on_create_resource_button_pressed() -> void:
	resource_manager.add_resource(name_line_edit.text, AWOCResource.new(), path_editor.get_asset_path())
	super()
	
	
func _on_awoc_edited(awoc_name: String) -> void:
	var awoc_uid: int = resource_manager.get_dictionary()[awoc_name]
	var awoc: AWOCResource = load(ResourceUID.get_id_path(awoc_uid)) as AWOCResource
	awoc_edited.emit(awoc_name, awoc, awoc_uid)
	
	
func _on_resource_renamed(old_name: String, new_name: String) -> void:
	resource_manager.rename_awoc(old_name, new_name)
	
	
