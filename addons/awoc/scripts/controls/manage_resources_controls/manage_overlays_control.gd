@tool
class_name AWOCManageOverlaysControl extends AWOCManageResourcesControlBase

func populate_resource_controls_area():
	super()
	for overlay_name in dictionary:
		pass
		"""var overlay_control = AWOCSlotControl.new(awoc_resource_controller, slot_name)
		overlay_control.control_reset.connect(emit_control_reset)
		control_panel_container_vbox.add_child(overlay_control)"""

func create_controls():
	tab_button = create_manage_resources_toggle_button("Manage Overlays")
	super()
