@tool
class_name AWOCFileDialog
extends FileDialog


func _init(dialog_title: String) -> void:
	title = dialog_title
	set_access(FileDialog.ACCESS_RESOURCES)
	set_current_dir("res://")
	set_initial_position(FileDialog.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN)
	size.x = 400
	size.y = 300
	visible = false
