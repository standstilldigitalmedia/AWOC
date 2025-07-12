@tool
class_name AWOCWelcomeTab
extends AWOCTabBase

signal awoc_edited(awoc_name: String, awoc: AWOCResource, awoc_uid: int)

var welcome_resource: AWOCEditorWelcomeResourceManager
var name_line_edit := AWOCLineEdit.new("AWOC Name")
var path_editor := AWOCPathEditor.new("Asset Creation Path")
var create_awoc_button := AWOCButton.new("Create AWOC")


func set_manage_button_disabled() -> void:
	if welcome_resource.has_resources():
		manage_resources_button.disabled = false
	else:
		manage_resources_button.disabled = true
		manage_resources_button.set_pressed_no_signal(false)
		
		
func reset_controls() -> void:
	name_line_edit.text = ""
	path_editor.reset_controls()
	create_awoc_button.disabled = true
	populate_manage_awocs_area()
	
func reset_tab() -> void:
	super()
	reset_controls()
	set_manage_button_disabled()
		
	
func parent_controls() -> void:
	super()
	new_resource_content_vbox.add_child(name_line_edit)
	new_resource_content_vbox.add_child(path_editor)
	new_resource_content_vbox.add_child(create_awoc_button)
	
	
func set_control_listeners() -> void:
	super()
	path_editor.validated.connect(_on_path_editor_validated)
	name_line_edit.text_changed.connect(_on_name_line_edit_text_changed)
	create_awoc_button.pressed.connect(_on_create_awoc_button_pressed)
	
		
func populate_manage_awocs_area() -> void:
	clear_manage_resources_area()
	for awoc_name in welcome_resource.get_sorted_name_array():
		var control := AWOCControl.new(awoc_name)
		control.rename.connect(_on_awoc_renamed)
		control.delete.connect(_on_awoc_deleted)
		control.edit.connect(_on_awoc_edited)
		manage_resources_content_vbox.add_child(control)
		

func _init() -> void:
	welcome_resource = AWOCEditorWelcomeResourceManager.new().load_welcome_resource_manager()
	super("New AWOC", "Manage AWOCs")
	
			
func _on_path_editor_validated(validated: bool) -> void:
	if validated:
		if AWOCGlobal.is_valid_name(name_line_edit.text):
			create_awoc_button.disabled = false
			return
	create_awoc_button.disabled = true
		
		
func _on_name_line_edit_text_changed(new_text: String) -> void:
	path_editor.validate()
	
	
func _on_create_awoc_button_pressed() -> void:
	welcome_resource.add_awoc(name_line_edit.text, path_editor.get_asset_path())
	reset_controls()
	set_manage_button_disabled()
	
	
func _on_awoc_renamed(old_name: String, new_name: String) -> void:
	welcome_resource.rename_awoc(old_name, new_name)
	reset_controls()
	
	
func _on_awoc_deleted(awoc_name) -> void:
	welcome_resource.delete_awoc(awoc_name)
	if welcome_resource.has_resources():
		reset_controls()
	else:
		reset_tab()
	
	
func _on_awoc_edited(awoc_name: String) -> void:
	var awoc_uid: int = welcome_resource.get_dictionary()[awoc_name]
	var awoc: AWOCResource = load(ResourceUID.get_id_path(awoc_uid)) as AWOCResource
	awoc_edited.emit(awoc_name, awoc, awoc_uid)
	
