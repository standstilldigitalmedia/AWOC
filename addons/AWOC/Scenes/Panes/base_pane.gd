@tool
class_name AWOCBasePane extends Node

@export var awoc_editor: Node

func get_file_name_from_path(path: String):
	#split the path at forward slashes
	var dir_split: PackedStringArray = path.split("/")
	var dir_split_size = dir_split.size()
	#the last element in the dir_split array is the file name
	#split the file name at the period so file_split[0] is the
	#file name without the extension
	var file_split = dir_split[dir_split_size - 1].split(".")
	return file_split[0]

func init_file_dialog(dialog: FileDialog):
	dialog.visible = false
	dialog.clear_filters()
	dialog.add_filter("*.res", "Resource")
	dialog.current_dir = "/"
