@tool
class_name AWOCManagerController
extends AWOCControllerBase

const AWOC_MANAGER_PATH: String = "res://addons/awoc/begin_here/awoc_manager.res"
var _awoc_manager_reference: AWOCEditorResourceReference
var _awoc_manager: AWOCManager

func _init() -> void:
	load_awoc_manager()
		
	
func load_awoc_manager() -> void:
	if _awoc_manager_reference == null:
		_awoc_manager_reference = AWOCEditorResourceReference.new(AWOCResourceReference.new())
		_awoc_manager_reference.set_res_path(AWOC_MANAGER_PATH)
		_awoc_manager = _awoc_manager_reference.load_res()
		if _awoc_manager == null:
			_awoc_manager = AWOCManager.new()
			_awoc_manager_reference.set_res(_awoc_manager)
			_awoc_manager_reference.save_res()
		
		
func add_new_awoc(awoc_name: String, asset_path: String) -> void:
	if res_exists(awoc_name):
		printerr("An AWOC named " + awoc_name + " already exists.")
		return
	var awoc_reference: AWOCResourceReference = (
			AWOCResourceReference.new())
	var editor_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(awoc_reference)
	editor_reference.set_res(AWOC.new())
	editor_reference.set_res_path(asset_path + "/" + awoc_name + ".res")
	editor_reference.save_res()
	_get_dictionary()[awoc_name] = awoc_reference
	_awoc_manager_reference.save_res()
	scan()
	
	
func delete_res(res_name: String) -> bool:
	var awoc_reference: AWOCEditorResourceReference = get_reference(res_name)
	awoc_reference.update_res_path()
	var awoc: AWOC = awoc_reference.load_res()
	for slot in awoc.slot_dictionary:
		var slot_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(awoc.slot_dictionary[slot])
		slot_reference.delete_res()
	if awoc.skeleton_reference != null:
		var skeleton_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(awoc.skeleton_reference)
		skeleton_reference.delete_res()
	for mesh in awoc.mesh_dictionary:
		var mesh_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(awoc.mesh_dictionary[mesh])
		mesh_reference.delete_res()
	for color in awoc.color_dictionary:
		var color_reference: AWOCEditorResourceReference = AWOCEditorResourceReference.new(awoc.color_dictionary[color])
		color_reference.delete_res()
	var deleted: bool = super(res_name)
	scan()
	if deleted:
		_awoc_manager_reference.save_res()
	return deleted
	

func rename_res(old_name: String, new_name: String) -> bool:
	var renamed: bool = super(old_name, new_name)
	scan()
	if renamed:
		_awoc_manager_reference.save_res()
	return renamed
	
	
func _get_dictionary() -> Dictionary[String, AWOCResourceReference]:
	return _awoc_manager.awoc_dictionary
	
