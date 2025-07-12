@tool
class_name AWOCFolderControlOverride extends LineEdit

func _can_drop_data(position, data):
	if data["type"] == "files_and_dirs":
		return true
	return true

func _drop_data(position, data):
	self.text = data["files"][0].get_base_dir()
	text_changed.emit(self.text)
