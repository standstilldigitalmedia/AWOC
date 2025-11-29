@tool
class_name AWOCGlobalSignalBus
extends Node

signal resource_modified(resource_type: AWOCResourceType.Type, result: String)
signal show_mesh(mesh_name: String, show: bool)
signal preview_content_changed(has_content: bool)
signal details_content_changed(has_content: bool)
