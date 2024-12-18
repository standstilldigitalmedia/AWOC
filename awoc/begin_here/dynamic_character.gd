class_name AWOCDynamicCharacter
extends Node3D

@export var awoc: AWOC

var skeleton: Skeleton3D
var mesh_dictionary: Dictionary[String, MeshInstance3D]
var material: ORMMaterial3D
