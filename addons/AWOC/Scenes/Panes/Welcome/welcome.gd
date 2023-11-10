@tool
extends AWOCBasePane

@export var new_awoc_dialog: FileDialog
@export var load_awoc_dialog: FileDialog

func _ready():
	init_file_dialog(load_awoc_dialog)
	init_file_dialog(new_awoc_dialog)
	
func _on_new_awoc_dialog_file_selected(path: String):
	#split the path at forward slashes
	var dir_split: PackedStringArray = path.split("/")
	var dir_split_size = dir_split.size()
	#the last element in the dir_split array is the file name
	#split the file name at the period so file_split[0] is the
	#file name without the extension
	var file_split = dir_split[dir_split_size - 1].split(".")
	awoc_editor.awoc_obj = AWOCRes.new()
	awoc_editor.awoc_obj.awoc_name = file_split[0]
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
