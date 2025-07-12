@tool
class_name AWOCSingleMeshControlOverride extends LineEdit

func _can_drop_data(position, data):
	if data["type"] == "nodes":
		var node_path: String = data["nodes"][0]
		var newmesh = get_node(node_path)
		return newmesh is MeshInstance3D
	return false

func _drop_data(position, data):
	var node_path: String = data["nodes"][0]
	self.text = node_path
	text_changed.emit(self.text)
