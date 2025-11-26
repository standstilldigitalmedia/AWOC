@tool
class_name AWOCEditorGlobal
extends Node

const WELCOME_BASE_PATH: String = "begin_here/"
const WELCOME_FILE_NAME: String = "welcome.tres"
const SCAN_ON_FILE_CHANGE: bool = true
const SEND_TO_RECYCLE: bool = false
static var plugin_path: String = "res://addons/AWOC/"
static var _scan_pending: bool = false


static func request_scan():
	if not SCAN_ON_FILE_CHANGE or _scan_pending:
		return
	_scan_pending = true
	Engine.get_main_loop().create_timer(0.3).timeout.connect(
		func():
			if EditorInterface.get_resource_filesystem():
				EditorInterface.get_resource_filesystem().scan()
			_scan_pending = false,
		CONNECT_ONE_SHOT
	)
