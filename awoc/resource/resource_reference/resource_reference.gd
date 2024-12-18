class_name AWOCResourceReference
extends Resource

@export var uid: int
@export var path: String
@export var _resource: AWOCResourceBase
	
	
func load_res() -> AWOCResourceBase:
	if FileAccess.file_exists(path):
		if _resource == null:
			_resource = load(path)
		return _resource
	return null
