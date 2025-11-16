@tool
class_name AWOCGlobalSignalBus
extends Node

signal create_new_resource_requested(data: Dictionary)
signal delete_resource_requested(name: String)
signal resource_renamed(old_name: String, new_name: String)
