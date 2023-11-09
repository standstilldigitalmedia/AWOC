@tool
extends Control

@export var welcome_pane: PackedScene
@export var slots_pane: PackedScene
@export var meshes_pane: PackedScene
@export var animations_pane: PackedScene
@export var materials_pane: PackedScene
@export var recipes_pane: PackedScene
@export var wardrobes_pane: PackedScene
@export var preview_pane: PackedScene

@export var slots_button: Button
@export var meshes_button: Button
@export var animations_button: Button
@export var materials_button: Button
@export var recipes_button: Button
@export var wardrobes_button: Button

@export var right_pane: CenterContainer
@export var main_container: HBoxContainer

var awoc_path: String
var awoc_obj: Resource
var current_pane: Node
var current_preview_pane: Node

func preview_awoc(mesh_list: Array):
	if awoc_obj != null and current_preview_pane != null:
		var new_subject: Node3D = awoc_obj.create_awoc_avatar(mesh_list)
		current_preview_pane.set_new_subject(new_subject)

func disable_left_nav(disable: bool):
	slots_button.disabled = disable
	meshes_button.disabled = disable
	animations_button.disabled = disable
	materials_button.disabled = disable
	recipes_button.disabled = disable
	wardrobes_button.disabled = disable

func load_pane(pane: PackedScene):
	if pane == welcome_pane:
		disable_left_nav(true)
	else:
		disable_left_nav(false)
		
	if current_pane != null:
		current_pane.queue_free()
	current_pane = pane.instantiate()
	current_pane.awoc_editor = self
	right_pane.add_child(current_pane)
	
func save_current_awoc():
	ResourceSaver.save(awoc_obj, awoc_path)
	
func _ready():
	load_pane(welcome_pane)
	current_preview_pane = preview_pane.instantiate()
	current_preview_pane.awoc_editor = self
	main_container.add_child(current_preview_pane)
	
func _on_slots_button_pressed():
	load_pane(slots_pane)

func _on_meshes_button_pressed():
	load_pane(meshes_pane)

func _on_materials_button_pressed():
	load_pane(materials_pane)

func _on_animations_button_pressed():
	load_pane(animations_pane)
	
func _on_recipes_button_pressed():
	load_pane(recipes_pane)

func _on_wardrobes_button_pressed():
	load_pane(wardrobes_pane)

func _on_reset_button_pressed():
	disable_left_nav(true)
	load_pane(welcome_pane)
