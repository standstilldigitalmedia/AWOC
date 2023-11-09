@tool
class_name AWOCBasePane extends Node

@export var awoc_editor: Node

func init_file_dialog(dialog: FileDialog):
	dialog.visible = false
	dialog.clear_filters()
	dialog.add_filter("*.res", "Resource")
	dialog.current_dir = "/"
