@tool
class_name AWOCFileBrowseDialog
extends AWOCFileDialog


func _init(dialog_title: String) -> void:
	super(dialog_title)
	set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
