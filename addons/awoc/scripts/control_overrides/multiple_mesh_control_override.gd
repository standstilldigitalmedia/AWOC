@tool
class_name AWOCMultipleMeshControlOverride extends LineEdit

func _can_drop_data(position, data):
	return AWOCControlBase.is_avatar_file(data["files"][0])
	return true

func _drop_data(position, data):
	self.text = data["files"][0]
	text_changed.emit(self.text)
