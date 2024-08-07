class_name AWOC extends AWOCResourceBase

@export var slots_dictionary: Dictionary
@export var avatar: AWOCAvatar

func get_asset_creation_path() -> String:
	return ""
	#return ResourceUID.get_id_path(uid).get_base_dir()
