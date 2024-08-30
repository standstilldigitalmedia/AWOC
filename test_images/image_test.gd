extends Node2D

@export var sprite: Sprite2D

func _ready() -> void:
	var texture_image = sprite.sprite
	var texture_bytes = texture_image.get_data()
	#for a in texture_bytes.size():
		#printerr(str(texture_bytes[a]) + " , ")
		
	var image = Image.create_from_data(texture_image.get_width(), texture_image.get_height(),false,texture_image.get_format(),texture_bytes)
	#image.set_data()
	#texture_image.set_data()
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(texture_image)
	sprite.texture = image_texture
	
