# AWOC
Avatar Wardrobe Organizer and Colorer


AWOC is currently being rewritten. If you look through the commits to this repository, you can find the original version under Prototype all the way back at the second commit. I included this commit only as a reference. Feel free to browse the old code to get a sense of how you shouldn’t develop software. 


As of this writing, the rewrite is far from complete but is going well. The following is from the prototype version. I’ve never shared my work with the community before. This is me, saying, “Hey. Look at what I did here.” I hope you find it useful.


## New AWOC


When you first enable the AWOC plugin, an extra tab will be added to the area to the upper left, next to the Scene and Import tabs. Clicking on this tab will show the main AWOC editor interface. Here we see the Welcome Tab.


![Welcome Tab](/images/welcome.png) 


Stretching across the top of the Welcome Tab is the home button labeled AWOC. Clicking on this button will return you to the Welcome Tab. Below, we have buttons for New AWOC and Manage AWOCs. Manage AWOCs is disabled because we don’t have any AWOCs to manage. Let’s fix that. Clicking on New AWOC reveals some inputs for us to create a new AWOC.


![New AWOC](/images/new_awoc.png) 


We’ll need to give our new AWOC a name. We’ll also need to specify an asset creation path. This is the location within our project where our new AWOC will be stored on disk. We can use the browse button to the right of the asset creation path line edit or we can drag a folder from our project into the line edit and Godot will enter the full path for us. 

Once a valid name and path have been entered, the Create AWOC button becomes enabled. Clicking on the Create AWOC button will, oddly enough, create our new AWOC at the specified location.  


![Creating a new AWOC](/images/create_awoc.png)


If we click on the new resource file we just created, we can see all the fun stuff we are about to discuss.


![Inspecting an AWOC](/images/inspector.png)


We’ll be going over the contents of the AWOC resource file as we make our way through the editor interface. Speaking of which, our Manage AWOCs button is now enabled so let’s manage some AWOCs. 


![Manage AWOCs](/images/manage_awocs.png)


We only have the one AWOC to manage for now, but that’s plenty enough for our purposes. As we add new AWOCs, they will appear here for us to manage. We can change the name of our AWOC and click on the button that looks like a floppy disk to save the new name. This will rename the AWOC both in the AWOC editor and on disk. There is no undo in AWOC… yet. The trash can is for deleting AWOCs. Again, this can not be undone, so make sure before you click. The far right button that looks like a pencil is for editing this AWOC. Clicking on it will open what I affectionately call the TabBar Tab. 


![TabBar Tab](/images/tabbar_tab.png)


We see that the label has changed from Welcome to the name of our AWOC. We have a load of tabs below the label. We’ll go over the tabs one by one in the order they appear from left to right. When we fist open the TabBar Tab, we are presented with the Slots tab.


## Slots


Slots are a way for AWOC to keep everything organized. You can think of them as a place to equip armor. For example, you might have slots named Head, Helmet, and Hair. Later on, when we create Recipes, we’ll see that each recipe needs a slot. So, if we try to equip a helmet and there is already a recipe loaded for the Helmet slot, AWOC will destroy the old helmet mesh, add the new helmet mesh, and adjust the UVs and material accordingly. We’ll get into that more later.


Each individual slot may have any number of hide slots. I didn’t put a ton of thought into that name. Anyway, lets say we have a head equipped in the Head slot and some hair equipped in the Hair slot. Now, we want to equip a helmet in the Helmet slot. This may work just fine depending on our model but in some cases, the hair mesh is probably going to poke out trough the helmet mesh. If that’s what we want, fine. If not, we probably want to use a hide slot.


Continuing with the example above, in the Manage Slots area, we could find the Helmet slot and set the Hair slot as a hide slot. Now, anytime we equip a helmet, the old helmet as well as the hair will be destroyed before the new helmet mesh is added. If we un-equip the helmet entirely, the hair comes back automagically. 


Clicking on New Slot will give us inputs to create a new slot. All we need is to give it a meaningful name. New Hide Slot and Manage Hide Slots are disabled because you need a slot to hide before you can create a hide slot. So, let’s create some slots. 


![New Slot](/images/new_slot.png)


Now that we have added some slots, we can add hide slots when we create new slots.


![New Hide Slot](/images/new_hide_slot.png)


We can also manage slots now.


![Manage Slots](/images/manage_slots.png)


We are already familiar with renaming and deleting from the Welcome Tab. Instead of a pencil, we have an eyeball now. Clicking on the eyeball shows the Hide Slot Tab for a given slot.


![Hide Slot Tab](/images/hide_slot_tab.png)


Here we can add any number of hide slots to a given slot. The AWOC editor will make sure we don’t add the same hide slot twice and will also take care or renaming and deleting hide slots when slots are renamed or deleted. As I am writing this, I realize there is nothing preventing us from making two slots hide each other. Is there any case where this would be useful? Perhaps just a warning with the option to continue or cancel would be best for this case.


## Meshes


Now for some fun stuff. AWOC is all about meshes and materials. In the prototype version of AWOC, mesh data was stored in individual custom resources on disk. These resources wound up being twice the size on disk as the original mesh. Not to mention the nightmare of keeping track of all those separate files. To be honest, I’m not even sure if the prototype version of AWOC will work in a final build because of the way it was loading meshes.


In the rewrite, mesh data is stored as an ArrayMesh in a dictionary in the AWOC resource. This keeps all of the AWOC resources within the AWOC resource itself so it doesn’t have to load additional resources from disk. However, this also means that if we load an AWOC, we also load all of the meshes associated with that AWOC, which defeats one of the benefits AWOC is supposed to offer.


The solution I came up with is exporting a somewhat pre-configured AWOC. The way it would work is once we create an AWOC for our 3D model, with all of the mesh and material information gathered together in Recipes, we could then specify any number of Recipes and a new AWOC would be created with just the information the specified Recipes depend on. We would still retain the ability to change colors dynamically and equip and un-equip clothing or armor or whatever. We would just have a much more limited set of meshes and materials.


![Meshes Tab](/images/meshes_tab.png)


In the Meshes tab under New Mesh(es), we have two inputs. The first is for an avatar file and the second is for a single mesh node. The browse button is missing for some reason but you can drag a .glb file into the Avatar File input the way we did with a folder earlier in the Welcome Tab. The mysteriously missing browse button will be back in the rewrite. I don't remember if I got the single mesh node functionality working in the prototype version. It probably won't be implemented in the rewrite until much later. 


The idea here is we have a 3D model with a bunch of different clothing, armor, weapons, etc. We drag it into the Avatar File input or browse for it and click on Add Mesh(es). The AWOC plugin will load the .glb or .fbx file (.fbx will be supported in the rewrite) we specified and first locate it's skeleton. In later versions of AWOC, I hope to support static meshes that don't have a rig. But for now, if your model doesn't have a skeleton, it won't work with AWOC. Once the skeleton is found, it is serialized into a custom resource. Next, the plugin loops through all of the skeleton's children, serializing each mesh as it goes. This is all done automatically and every mesh that is a child of the skeleton is added.


The Single Mesh Node input was intended to add single meshes rigged to the same skeleton to an existing AWOC. This probably won't be needed often so it is not on the top of the priority list. We drag our 3D character into an scene and show all its children. Then, you can drag a single mesh from the node tree into this input and add it to an exiting AWOC. The skeleton will not be re-serialized so you can only use this feature with an AWOC that already has a skeleton.


Now that we've added some meshes, we can manage them.


![Manage Meshes](/images/manage_meshes.png)


Once again, we have options to rename and delete individual meshes as we've seen before. We also have the eye like we did with slots but it does something extra special this time around. Clicking on the eye allows us to preview the mesh as AWOC will rebuild it. Click on more than one eye to see a preview of multiple meshes together. 


![Mesh Preview](/images/mesh_preview.png)


We have buttons to rotate the model left and right, move the model up, down, left, and right, zoom in, zoom out and center the camera back at its default. We can change the axis on which the rotation occurs by selecting an axis under Rotate Axis. We can also control move speed, rotate speed, and zoom speed. In our build, we simply pass an array with the names of the meshes we want to show to a single function and wahla! AWOC does the rest. Not that we would want to do this. It is much better to create our AWOC from Recipes as this will include material and slot information. We'll get into recipes soon. But first...


## Colors


Don't worry. We don't have to specify every color our AWOC will use. Instead, we use colors to share a color between multiple different meshes. Let's say we have a model with separate meshes for Head, Torso, Arms, and Legs. To complicate things a bit, on our arms, we have short sleeves. This means that some of our character's flesh is showing. Since each of these meshes has a different material, we'd have to make sure we change the color of the area associated with flesh to the same color for each mesh. That's where colors come in.


This will make a little more sense once we get into overlays. But for now, just know that the color tab allows you to create colors you can share across materials. For example, we could create a color called Flesh. In our material, we specify that a given overlay is to use the color Flesh instead of the regular overlay color. Now, we can change the color named Flesh in one place and any material that uses Flesh will automagically change its color. If that doesn't make much sense, don't worry. We'll come back to Colors once we understand how AWOC handles materials a little better.


![Color Tab](/images/color_tab.png)


Clicking on New Color gives us an input for color name and a black color picker box. Once we create a new color, we can manage it.


![Manage Colors](/images/manage_colors.png)


Again, we can rename or delete here. Instead of a pencil or eye, we just have a color picker button. Changing the color here will change it in the AWOC immediately. There is no undo. Yet.


## Materials


The name may be misleading as one of the goals of AWOC is to only have one material for all of the meshes in our AWOC. AWOC does this by combining the images we specify for each material into one huge image and then offsets the UVs of each mesh so they land where they are supposed to on the combined image. In the editor, our AWOC will have many different materials. But at runtime, there will only be one. 


Currently, I have only gotten as far as albedo, though the prototype version allows you to specify ORM or Occlusion, Roughness and Metallic separately. The idea here is that regardless of which option you select, AWOC will combine everything into a single ORM image. AWOC will also support ALL material images such as emission, normal, rim, clear coat, etc. and more material properties than it currently supports. 


Each material may also have any number of overlays. An overlay is a way of stacking images on top of each other. For example, we might want our model to have a tattoo. This can be accomplished with an image overlay. Or we might want to be able to color the iris of our model's eyes dynamically. This can be accomplished with a dynamic color overlay. We can also create a color overlay which works the same as a dynamic color overlay except that it uses one of the colors we specified instead of its own color. 


For an image overlay, we will need an image that is the same size as all of our other material images. AWOC does not support material images of varying sizes. For the tattoo example, we'd have the image of the tattoo in an appropriate position and scale to align with our UVs and everything else should be transparent. Here in a minute, we will see that we can adjust the strength of overlays in the AWOC editor so we could make the tattoo appear faded, for example. I’d like to add the ability to move and scale image overlays visually in the AWOC editor but that will be far, far in the future. For now, you will have to use Blender to line up images for image overlays.


For dynamic color overlays and color overlays, we need a mask. For the mask, AWOC only cares if there is red information or not. I generally make mine white where I want color to overlay and transparent everywhere else but we could just use red if we like. The alpha channel is currently completely ignored for the purposes of overlays but this may change in the future. 


![Materials Tab](/images/materials_tab.png)


The Materials Tab for a new AWOC will show the Material Properties area when creating a new AWOC. Here, we can specify which properties our AWOC material will utilize. This will only need to be set once and once set, can not be changed. If, for example, you check Roughness and then Apply Settings, every material you create for that AWOC will need a Roughness image specified. At some point, I may include the option to automatically create a blank image for images that aren’t specified but for now, we will have to create our own blanks manually in Gimp.


Note that in the image above, only a few of the options are shown. The final version of AWOC will have many more options here.


![New Material](/images/new_material.png)


Once we have applied our material settings, we can create new materials. We’ll first give our material a name. Then, we can begin to fill in the various images this material will use. You can either drag an image from your project or use the browse button to browse your project directory. Once an image is selected, a preview of the image will be shown instead of the words NO IMAGE. Once all of our images have been specified, we can click on Create Material. Note that I selected additional material properties for this image just to show how that would look but for the rest of this AWOC, I will only be using albedo.