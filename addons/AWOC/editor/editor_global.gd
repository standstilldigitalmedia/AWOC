@tool
class_name AWOCEditorGlobal
extends Node

const SCAN_ON_FILE_CHANGE: bool = true
const SEND_TO_RECYCLE: bool = false
const WELCOME_RESOURCE_PATH: String = "res://addons/AWOC/begin_here/welcome.res"


static func scan():
	if SCAN_ON_FILE_CHANGE:
		EditorInterface.get_resource_filesystem().scan()
