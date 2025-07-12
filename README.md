# AWOC
Avatar Wardrobe Organizer and Colorer


AWOC is currently being rewritten. If you look through the commits to this repository, you can find the original version under Prototype. I included this commit only as a reference. Feel free to browse the old code to get a sense of how you shouldn’t develop software. Not that the rewrite is probably much better, but I digress.


As of this writing, the rewrite is far from complete but is going well. The following is from the prototype version. I’ve never shared my work with the community before. This is me, saying, “Hey. Look at what I did here.” I hope you find it useful.


##New AWOC
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


##Slots


Slots are a way for AWOC to keep everything organized. You can think of them as a place to equip armor. For example, you might have slots named Head, Helmet, and Hair. Later on, when we create Recipes, we’ll see that each recipe needs a slot. So, if we try to equip a helmet and there is already a recipe loaded for the Helmet slot, AWOC will destroy the old helmet mesh, add the new helmet mesh, and adjust the uvs and material accordingly. We’ll get into that more later.


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


Here we can add any number of hide slots to a given slot. The AWOC editor will make sure we don’t add the same hide slot twice and will also take care or renaming and deleting hide slots when slots are renamed or deleted. As I am writing this, I realize there is nothing preventing us from making two slots hide each other. Is there any case where there would be useful? Perhaps just a warning with the option to continue or cancel would be best for this case.


##Meshes


Now for some fun stuff. AWOC is all about meshes and materials. In the prototype version of AWOC, mesh data was stored in individual custom resources on disk. These resources wound up being twice the size on disk as the original mesh. Not to mention the nightmare of keeping track of all those separate files. To be honest, I’m not even sure if the prototype version of AWOC will work in a final build because of the way it was loading meshes.


In the rewrite, mesh data is stored as an ArrayMesh in a dictionary in the AWOC resource. This keeps all of the AWOC resources within the AWOC resource itself so it doesn’t have to load additional resources from disk. However, this also means that if we load an AWOC, we also load all of the meshes associated with that AWOC, which defeats one of the benefits AWOC is supposed to offer.


The solution I came up with is exporting a somewhat pre-configured AWOC. The way it would work is once you create an AWOC for your 3D model, with all of the mesh and material information gathered together in Recipes, you could then specify any number of Recipes and a new AWOC would be created with just the information the specified Recipes depend on. You would still retain the ability to change colors dynamically and equip and unequip clothing or armor or whatever. You would just have a much more limited set of meshes and materials.


   
