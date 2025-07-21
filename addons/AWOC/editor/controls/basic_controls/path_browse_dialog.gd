@tool
class_name AWOCPathBrowseDialog
extends AWOCFileDialog


func _init(dialog_title: String) -> void:
	super(dialog_title)
	set_file_mode(FileDialog.FILE_MODE_OPEN_DIR)
