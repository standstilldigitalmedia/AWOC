@tool
class_name AWOCManageAWOCControl extends AWOCManageResourceControlBase

signal awoc_edited(awoc: AWOCResourceController)

var edit_button: Button
var awoc_resource_controller: AWOCResourceController

func validate_inputs():
	pass
	
func _on_delete_confirmed():
	awoc_resource_controller.delete_resource()
	resource_deleted.emit()
	
func _on_rename_confirmed():
	awoc_resource_controller.rename_resource(name_line_edit.text)
	resource_renamed.emit()
	
func _on_rename_button_pressed():
	rename_confirmation_dialog = create_rename_confirmation_dialog(awoc_resource_controller.resource.name)
	rename_confirmation_dialog.visible = true
	main_panel_container.add_child(rename_confirmation_dialog)
	
func _on_delete_button_pressed():
	delete_confirmation_dialog = create_delete_confirmation_dialog(awoc_resource_controller.resource.name)
	delete_confirmation_dialog.visible = true
	main_panel_container.add_child(delete_confirmation_dialog)
	
func _on_edit_button_pressed():
	awoc_edited.emit(awoc_resource_controller)
	
func create_controls():
	name_line_edit = create_line_edit("AWOC Name", awoc_resource_controller.resource.name)
	edit_button = create_edit_button()
	super()
	
func parent_controls():
	var hbox = create_hbox(5)
	hbox.add_child(name_line_edit)
	hbox.add_child(rename_button)
	hbox.add_child(delete_button)
	hbox.add_child(edit_button)
	main_panel_container.add_child(hbox)

func _init(a_resource_controller: AWOCResourceController):
	awoc_resource_controller = a_resource_controller
	create_controls()
	parent_controls()
