@tool
class_name AWOCMeshManagementRow
extends AWOCBaseManagementRow


func _on_show_hide_button_toggled(toggled_on: bool) -> void:
	SignalBus.show_mesh.emit(previous_name, toggled_on)
