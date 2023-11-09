@tool
extends AWOCBasePane

@export var slot_container: PackedScene
@export var add_slot_name_edit: LineEdit
@export var slots_scroll_container: VBoxContainer

func set_slot_name(slot_name: String, slot_obj: Node):
	slot_obj.set_slot_name(slot_name)

func populate_slots_container():
	if awoc_editor != null and awoc_editor.awoc_obj != null:
		if awoc_editor.awoc_obj.slots_dictionary == null:
			awoc_editor.awoc_obj.slots_dictionary = {}
			return
		for child in slots_scroll_container.get_children():
			child.queue_free()
		for slot in awoc_editor.awoc_obj.slots_dictionary:
			var container = slot_container.instantiate()
			container.awoc_editor = awoc_editor
			container.set_slot_name(slot)
			slots_scroll_container.add_child(container)

func _on_add_slot_button_pressed():
	var new_slot_name: String = add_slot_name_edit.get_text()
	if new_slot_name != null and new_slot_name.length() > 1 and awoc_editor.awoc_obj != null:
		awoc_editor.awoc_obj.slots_dictionary[new_slot_name] = []
		awoc_editor.save_current_awoc()
		populate_slots_container()
		
func _ready():
	populate_slots_container()
