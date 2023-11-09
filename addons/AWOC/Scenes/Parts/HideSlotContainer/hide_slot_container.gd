@tool
extends AWOCBasePane

@export var confirm_delete_dialog: ConfirmationDialog 
@export var hide_slot_label: Label

var prev_name
var slot_name

func set_slot_name(slot_name: String):
	hide_slot_label.set_text(slot_name)
	prev_name = slot_name

func _ready():
	confirm_delete_dialog.visible = false

func _on_delete_hideslot_button_pressed():
	confirm_delete_dialog.title = "Delete " + prev_name + "?"
	confirm_delete_dialog.dialog_text = "Are you sure you wish to delete " + prev_name + "? This can not be undone."
	confirm_delete_dialog.visible = true

func _on_confirm_delete_hide_slot_dialog_confirmed():
	awoc_editor.awoc_obj.slots_dictionary[slot_name].erase(prev_name)
	awoc_editor.save_current_awoc()
	self.queue_free()
