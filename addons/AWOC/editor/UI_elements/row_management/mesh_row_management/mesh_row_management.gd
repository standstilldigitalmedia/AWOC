@tool
class_name AWOCMeshRowManagement
extends AWOCRowManagementBase

signal visibility_toggled(toggled_on: bool)

@export var eye_button: Button


func _on_show_hide_button_toggled(toggled_on: bool) -> void:
	var signal_bus: AWOCGlobalSignalBus = AWOCEditorGlobal.get_signal_bus()
	if signal_bus:
		signal_bus.show_mesh.emit(previous_name, toggled_on)
	visibility_toggled.emit(toggled_on)
