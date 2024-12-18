@tool
class_name AWOCImageControlOverride extends LineEdit

func _can_drop_data(position, data):
	if data["type"] == "files":
		return AWOCControlBase.is_image_file(data["files"][0])
		return true
	return false

func _drop_data(position, data):
	self.text = data["files"][0]
	text_changed.emit(self.text)
