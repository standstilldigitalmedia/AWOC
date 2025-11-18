@tool
class_name AWOCGlobalSignalBus
extends Node

signal create_new_resource_requested(data: Dictionary)
signal delete_resource_requested(resource_type: String, resource_name: String)
signal rename_resource_requested(resource_type: String, old_name: String, new_name: String)

signal resource_created(resource: Resource)
signal resource_deleted(resource_path: String)
