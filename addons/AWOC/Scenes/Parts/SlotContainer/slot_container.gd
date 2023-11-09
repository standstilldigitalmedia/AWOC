@tool
extends AWOCBasePane

@export var slot_controls_container: HBoxContainer
@export var hide_slot_container: ColorRect
@export var slot_button: Button
@export var slot_name_edit: LineEdit 
@export var confirm_save_dialog: ConfirmationDialog
@export var confirm_delete_dialog: ConfirmationDialog
@export var show_button: Button 
@export var hide_button: Button
@export var hide_slot_select: OptionButton 
@export var hide_slot_scroll_container: VBoxContainer 
@export var hide_slot_container_scene: Resource

var prev_name: String

func populate_hide_slot_select():
	if awoc_editor != null and awoc_editor.awoc_obj != null:
		hide_slot_select.clear()
		for slot in awoc_editor.awoc_obj.slots_dictionary:
			if slot != prev_name:
				hide_slot_select.add_item(slot)
				
func set_hide_slot_name(hide_slot_name: String, hide_slot: Node):
	hide_slot.set_slot_name(hide_slot_name)

func populate_hide_slot_container():
	if awoc_editor != null and awoc_editor.awoc_obj != null:
		for child in hide_slot_scroll_container.get_children():
			child.queue_free()
		for hide_slot in awoc_editor.awoc_obj.slots_dictionary[prev_name]:
			var new_hide_slot = hide_slot_container_scene.instantiate()
			new_hide_slot.awoc_editor = awoc_editor
			new_hide_slot.slot_name = prev_name
			new_hide_slot.set_slot_name(hide_slot)
			hide_slot_scroll_container.add_child(new_hide_slot)

func show_controls(show: bool):
	slot_controls_container.visible = show
	hide_slot_container.visible = show
	
func set_slot_name(slot_name: String):
	slot_button.set_text(slot_name)
	slot_name_edit.set_text(slot_name)
	prev_name = slot_name
	populate_hide_slot_container()
	
func _on_slot_button_toggled(button_pressed):
	slot_controls_container.visible = button_pressed

func _ready():
	show_controls(false)
	confirm_save_dialog.visible = false
	confirm_delete_dialog.visible = false

func _on_save_button_pressed():
	confirm_save_dialog.title = "Rename " + prev_name + "?"
	confirm_save_dialog.dialog_text = "Are you sure you wish to rename " + prev_name + "? This can not be undone."
	confirm_save_dialog.visible = true
	
func _on_confrim_save_dialog_confirmed():
	var new_name: String = slot_name_edit.get_text()
	awoc_editor.awoc_obj.slots_dictionary[new_name] = []
	for slot in awoc_editor.awoc_obj.slots_dictionary[prev_name]:
		awoc_editor.awoc_obj.slots_dictionary[new_name].append(slot)
	awoc_editor.awoc_obj.slots_dictionary.erase(prev_name)
	set_slot_name(new_name)
	awoc_editor.save_current_awoc()

func _on_delete_button_pressed():
	confirm_delete_dialog.title = "Delete " + prev_name + "?"
	confirm_delete_dialog.dialog_text = "Are you sure you wish to delete " + prev_name + "? This can not be undone."
	confirm_delete_dialog.visible = true
	
func _on_confirm_delete_dialog_confirmed():
	awoc_editor.awoc_obj.slots_dictionary.erase(prev_name)
	self.queue_free()

func _on_show_button_pressed():
	show_button.visible = false
	hide_button.visible = true
	hide_slot_container.visible = true
	populate_hide_slot_select()

func _on_hide_button_pressed():
	show_button.visible = true
	hide_button.visible = false
	hide_slot_container.visible = false

func _on_add_hide_slot_button_pressed():
	var new_hide_slot: String = hide_slot_select.get_item_text(hide_slot_select.get_selected_id())
	if new_hide_slot != null and new_hide_slot.length() > 1:
		for hide_slot in awoc_editor.awoc_obj.slots_dictionary[prev_name]:
			if hide_slot == new_hide_slot:
				return
		awoc_editor.awoc_obj.slots_dictionary[prev_name].append(new_hide_slot)
		populate_hide_slot_container()
		awoc_editor.save_current_awoc()
		
