@tool
extends AWOCBasePane

@export var new_awoc_dialog: FileDialog
@export var load_awoc_dialog: FileDialog

func _ready():
	init_file_dialog(load_awoc_dialog)
	init_file_dialog(new_awoc_dialog)
	
func _on_new_awoc_dialog_file_selected(path: String):
	awoc_editor.awoc_obj = AWOCRes.new()
	awoc_editor.awoc_obj.awoc_name = get_file_name_from_path(path)
	awoc_editor.awoc_path = path
	awoc_editor.save_current_awoc()
	awoc_editor.load_pane(awoc_editor.slots_pane)

func _on_load_awoc_dialog_file_selected(path: String):
	var temp_awoc: Resource = load(path)
	if temp_awoc is AWOCRes:
		awoc_editor.awoc_path = path
		awoc_editor.awoc_obj = temp_awoc
		temp_awoc.load_source_avatar()
		awoc_editor.load_pane(awoc_editor.slots_pane)

func _on_new_awoc_button_pressed():
	new_awoc_dialog.visible = true

func _on_load_awoc_button_pressed():
	load_awoc_dialog.visible = true
