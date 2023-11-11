extends Control

var image_colors = []
var loaded_images = []
var final_image : Image
var final_image_data = []
var config: ConfigFile
const CONFIG_PATH = "res://testConfig.cfg"
const TEXTURE_WIDTH = 512
const TEXTURE_HEIGHT = 512

func write_config():
	#config.set_value("planner_section","planner_json",JSON.stringify(config_obj))
	config.save(CONFIG_PATH)
	
func read_config():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if err != OK:
		config = ConfigFile.new()
		config.set_value("planner_section", "planner_json", "")
		return
		
	var json = JSON.new()
	var json_string = config.get_value("planner_section", "planner_json")
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		#config_obj = data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func delete_config():
	DirAccess.remove_absolute(CONFIG_PATH)
	read_config()
	
func get_pixel_array(index):
	var return_obj = []
	var texture = ImageTexture.create_from_image(loaded_images[index])
	var pixel_array = texture.get_image().get_data()
	for a in range(0, pixel_array.size(), 4):
		if pixel_array[a] > 0:
			return_obj.append(a)
	return return_obj

func append_final_image(index):
	var texture = ImageTexture.create_from_image(loaded_images[index])
	var pixel_array = texture.get_image().get_data()
	for a in range(0, pixel_array.size(), 4):
		if pixel_array[a] > 0:
			final_image_data[a] = image_colors[index].r * 255
			final_image_data[a+1] = image_colors[index].g * 255
			final_image_data[a+2] = image_colors[index].b * 255
			final_image_data[a+3] = image_colors[index].a * 255
	
func append_all_images():
	for a in loaded_images.size():
		append_final_image(a)
	
func init_final_image():
	final_image = Image.create(512, 512, false, Image.FORMAT_RGBA8)
	for a in TEXTURE_WIDTH:
		for b in TEXTURE_HEIGHT:
			final_image.set_pixel(a,b,Color(0.0,0.0,1.0,1.0))
	var texture = ImageTexture.create_from_image(final_image)
	final_image_data = texture.get_image().get_data()

func init_image_strings():
	loaded_images.append(load("res://pieces/cape/cape_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/cape/cape_secondry.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/face/hair.png"))
	image_colors.append(Color(1.0,0.5,0.0,1.0))
	loaded_images.append(load("res://pieces/face/lips.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/face/scars.png"))
	image_colors.append(Color(0.6,0.3,0.3,1.0))
	loaded_images.append(load("res://pieces/face/skin.png"))
	image_colors.append(Color(0.8,0.5,0.5,1.0))
	loaded_images.append(load("res://pieces/face/undies.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/feet/feet_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/feet/feet_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/feet/feet_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/feet/feet_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/feet/feet_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/feet/feet_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/feet/feet_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/hands/hands_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/hands/hands_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/hands/hands_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/hands/hands_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/hands/hands_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/hands/hands_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/hands/hands_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_feather1.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_feather2.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_feather3.png"))
	image_colors.append(Color(0.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/helmet/helmet_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/helmet/helmet_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/legs/legs_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/legs/legs_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/legs/legs_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/legs/legs_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/legs/legs_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/legs/legs_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/legs/legs_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/shield/shield_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/shield/shield_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/shield/shield_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/shield/shield_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/shield/shield_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/shield/shield_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/shield/shield_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/torso/torso_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/torso/torso_fifth.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/torso/torso_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/torso/torso_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/torso/torso_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/torso/torso_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/torso/torso_sixth.png"))
	image_colors.append(Color(0.5,0.0,0.5,1.0))
	loaded_images.append(load("res://pieces/torso/torso_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/torso/torso_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_buckles.png"))
	image_colors.append(Color(0.0,1.0,1.0,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_fourth.png"))
	image_colors.append(Color(1.0,1.0,0.0,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_leather.png"))
	image_colors.append(Color(0.323,0.257,0.13,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_primary.png"))
	image_colors.append(Color(0.0,0.0,1,1))
	loaded_images.append(load("res://pieces/weapon/weapon_second.png"))
	image_colors.append(Color(1.0,0.0,0.0,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_studs.png"))
	image_colors.append(Color(1.0,0.0,1.0,1.0))
	loaded_images.append(load("res://pieces/weapon/weapon_third.png"))
	image_colors.append(Color(0.0,1.0,0.0,1.0))
	
func _ready():
	init_image_strings()
	print("images loaded")
	init_final_image()
	print("final image init")
	append_all_images()
	print("all images appended")
	
	
	var img = Image.create_from_data(512,512,false,Image.FORMAT_RGBA8,final_image_data)
	var texture = ImageTexture.create_from_image(img)
	$TextureRect.texture = texture	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
