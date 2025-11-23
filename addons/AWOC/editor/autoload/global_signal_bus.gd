@tool
class_name AWOCGlobalSignalBus
extends Node

signal delete_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String)
signal rename_resource_requested(resource_type: AWOCResourceType.Type, old_name: String, new_name: String)
signal create_new_resource_requested(resource_type: AWOCResourceType.Type, resource_name: String, additional_data: Dictionary) 
signal resource_modified(resource_type: AWOCResourceType.Type, result: String)
