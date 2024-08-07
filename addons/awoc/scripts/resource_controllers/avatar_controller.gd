@tool
class_name AWOCAvatarController extends AWOCResourceControllerBase
 
#create mesh resources
#create skeleton resource
	#if not skeleton ???
#rename mesh resources
#delete mesh resources

"""func create_avatar(avatar_file_path: String):
	var avatar_res: AWOCAvatar = AWOCAvatar.new()
	var avatar = load(avatar_file_path)
	var skeleton_res: AWOCSkeleton = AWOCSkeleton.new()
	var skeleton: Skeleton3D = skeleton_res.recursive_get_skeleton(avatar)
	if skeleton == null:
		pass
	else:
		skeleton_res.serialize_skeleton(skeleton)
		#var skeleton_controller: AWOCDiskResourceController = AWOCDiskResourceController.new(res: AWOCResourceBase, awoc: AWOC, dict: Dictionary, res_path: String)
	"""	

func _init(awoc: AWOC):
	pass
	#awoc_resource = awoc
