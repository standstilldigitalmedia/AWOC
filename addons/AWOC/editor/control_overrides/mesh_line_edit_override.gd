@tool
class_name AWOCMeshLineEdit
extends LineEdit


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data.has("nodes") or data.has("files"):
		return true
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data.has("nodes"):
		var node_path = data["nodes"][0]
		var root = EditorInterface.get_edited_scene_root()
		var target_node = root.get_node_or_null(node_path)
		if target_node:
			var relative_path = root.get_path_to(target_node)
			self.text = str(relative_path)
			text_changed.emit(self.text)
	elif data.has("files"):
		self.text = data["files"][0]
		text_changed.emit(self.text)
