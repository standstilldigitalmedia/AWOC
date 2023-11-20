# AWOC
 Avatar Wardrobe Organizer and Colorer
 
This plugin is currently under development. At any given time, the code in this repository may be completely broken, although I only push commits after I get something working. At this stage of development, it is use at your own risk.
 
 AWOC is a plugin I am currently developing that eases the burden of creating a 3D avatar that can be dynamically customized at runtime. You'll be able to load a single 3D model with as many clothing items as you like all rigged to the same skeleton. AWOC will first make a copy of the source skeleton and then combine only the meshes and materials you specify into a single textured mesh that is controlled by the copy of the source skeleton. Metallic, Rougness, and Heightmap properties will be combined into a single texture using the red channel for metallic, the green channel for roughness, and the blue channel for heightmap. 

AWOC takes the pain out of combining multiple textures into a larger texture and then offsetting the UVs of each mesh to match the new placement of the smaller texture in the larger texture by doing all of this for you dynamically. You just specify any number of Slots in the AWOC edior, assign a mesh and texture to a given Slot, for example, “Helmet,” and AWOC does all the magic behind the scenes.  

Slots will keep AWOC from, for example, equipping two helmets at the same time. You don't have to worry about whether another helmet is already equipped. You just tell AWOC which helmet you want to equip and AWOC takes care of the rest. Each Slot can also have any number of HideSlots. These are Slots that are automatically unequipped when this Slot is equipped and automatically re-equipped when this Slot is unequipped.

For example, let's say you have an AWOC with the following slots: Helmet, Hair, and Beard. You can set Hair and Beard as HideSlots of Helmet so your hair and beard don't poke through the helmet when it gets equppied.  

But AWOC goes a step further and allows you to create Recipes and Wardrobes. A Recipe allows you to preset things like color, metallic, etc. for a given texture for a given mesh. You can then load the Recipe onto your avatar with a single line of code. The colors and other properties set in a recipe are just initial values. All of the material properties can be changed dynamically at runtime.

Wardrobes are just a collection of Recipes. But instead of being colored dynamically, the colors, metallic, heightmap, etc. are all baked into textures that are saved to disk. This makes equipping an entire wardrobe more efficient than equipping single recipes but at the cost of not being dynamically modifiable. This is useful if, for example, you have an entire army that will all be wearing the same uniform. You can make as many copies as you want and each copy will share the same material.

I am working on some aspect of AWOC every spare moment I have and it is coming along nicely. However, I can't do this without you. Your input is invaluable to me. Feel free to reach out to me on the Godot forms at https://godotforums.org/u/standstill with any suggestions, comments, or concerns you may have. This is your plugin too so help me make it a good one.
 
