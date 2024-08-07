@tool
class_name AWOCMultipleMeshControlOverride extends LineEdit

func _can_drop_data(position, data):
	if data.has("files") and data["files"].size() > 0:
		return AWOCControlBase.is_avatar_file(data["files"][0])
	return false

func _drop_data(position, data):
	self.text = data["files"][0]
	text_changed.emit(self.text)
