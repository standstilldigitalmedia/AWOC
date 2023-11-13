using System.Collections.Generic;
using Godot;

namespace AWOC
{
	enum MatType
	{
		COLOR,
		METALLIC,
	}

	[Tool]
	public partial class AWOCEditor : Control
	{
		/// The various panes that will be loaded into the center of the editor window
		[Export] public PackedScene welcomePane;
		[Export] public PackedScene slotsPane;
		[Export] public PackedScene meshesPane;
		[Export] public PackedScene materialsPane;
		[Export] public PackedScene recipesPane;
		[Export] public PackedScene wardrobesPane;
		[Export] public PackedScene animationsPane;
		/// The various preview panes that will be loaded into the right side of the editor window
		[Export] public PackedScene meshPreviewPane;
		[Export] public PackedScene materialPreviewPane;

		/// Each button corresponds to a pane above. When clicked, the old center pane is released and the 
		/// new pane is added 
		[Export] Button slotsButton;
		[Export] Button meshesButton;
		[Export] Button materialsButton;
		[Export] Button recipesButton;
		[Export] Button wardrobesButton;
		[Export] Button animationsButton;

		/// The right pane where preview panes are parented
		[Export] CenterContainer rightPane;
		/// The center pane where the regular panes are parented
		[Export] HBoxContainer mainContainer;

		[Export] public AWOCRes awocObj;
		public BaseCenterPane currentPane;
		public BasePreviewPane currentPreviewNode;

		public string awocPath;

		/// <summary>
		/// Saves the current AWOC to disk at awocPath
		/// awocPath is set when the AWOC is loaded
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		public void SaveCurrentAWOC()
		{
			ResourceSaver.Save(awocObj, awocPath);
		}

		/// <summary>
		/// Frees the currentPreviewNode and then adds the previewPane specified
		/// in the paramater previewPane to the right side pane
		/// </summary>
		/// <param name="previewPane">The preview pane to be added to the right side of the AWOC editor window</param>
		/// <returns>void</returns>
		void LoadPreview(PackedScene previewPane)
		{
			if(currentPreviewNode != null)
			{
				currentPreviewNode.QueueFree();
			}
			currentPreviewNode = previewPane.Instantiate<BasePreviewPane>();
			currentPreviewNode.awocEditor = this;
			mainContainer.AddChild(currentPreviewNode);
		}


		/// <summary>
		/// I need to do some work to the preview panes before this function does anything useful
		/// </summary>
		/// <param name="texture">The texture to be previewed in the preview pane</param>
		/// <returns>void</returns>
		void PreviewMaterial(Texture2D texture)
		{
			LoadPreview(materialPreviewPane);
			//currentPreviewNode.SetPreviewTexture(texture);
		}

		/// <summary>
		/// Set Disabled on all of the buttons on in the left naviagation pane
		/// to the value in the parameter disable
		/// </summary>
		/// <param name="disable">A boolean that either enables or disables the buttons in the left navigation pane/param>
		/// <returns>void</returns>
		void DisableLeftNav(bool disable)
		{
			slotsButton.Disabled = disable;
			meshesButton.Disabled = disable;
			animationsButton.Disabled = disable;
			materialsButton.Disabled = disable;
			recipesButton.Disabled = disable;
			wardrobesButton.Disabled = disable;
		}
		
		/// <summary>
		/// Cleans up the AWOC editor window and then loads the pane specified in the paramater pane and parents it to the
		/// pane in the center of the AWOC editor window
		/// </summary>
		/// <param name="pane">The pane to parent to the pane in the center of the AWOC editor window</param>
		/// <returns>void</returns>
		public void LoadPane(PackedScene pane)
		{
			//if loading welcomePane, disable the buttons in the left navigation
			//otherwise, enable them
			if(pane == welcomePane)
				DisableLeftNav(true);
			else
				DisableLeftNav(false);
			
			//individual panes will load their own version of the preview pane so whichever one is
			//currently enabled gets QueueFreed
			if(currentPreviewNode != null)
			{
				currentPreviewNode.QueueFree();
			}

			//if there is a pane showing in the middle of the AWOC editor window, free it before adding the new one
			if(currentPane != null)
			{
				currentPane.QueueFree();
			}

			//now that all the old stuff has been freed, the new pane can be instantiated and parented to the right pane	
			currentPane = pane.Instantiate<BaseCenterPane>();
			currentPane.InitPane(this);
			currentPane.awocEditor = this;
			rightPane.AddChild(currentPane);
		}

		/// <summary>
		/// Loads the Slots pane in response to the Slots button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_slots_button_pressed()
		{
			LoadPane(slotsPane);
		}
	
		/// <summary>
		/// Loads the Meshes pane in response to the Meshes button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_meshes_button_pressed()
		{
			LoadPane(meshesPane);
		}

		/// <summary>
		/// Loads the Materials pane in response to the Materials button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_materials_button_pressed()
		{
			LoadPane(materialsPane);
		}
	
		/// <summary>
		/// Loads the Recipes pane in response to the Recipes button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_recipes_button_pressed()
		{
			LoadPane(recipesPane);
		}
	
		/// <summary>
		/// Loads the Wardrobes pane in response to the Wardrobes button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_wardrobes_button_pressed()
		{
			LoadPane(wardrobesPane);
		}

		/// <summary>
		/// Loads the Animations pane in response to the Animations button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_animations_button_pressed()
		{
			LoadPane(animationsPane);
		}
	
		/// <summary>
		/// Loads the Welcome pane in response to the large button at the top of the AWOC editor window being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_reset_button_pressed()
		{
			LoadPane(welcomePane);
		}
		
		public override void _Ready()
		{
			LoadPane(welcomePane);
		}
	}
}

/*

func preview_awoc_meshes(mesh_list: Array):
	load_preview(mesh_preview_pane)		
	if awoc_obj != null and current_preview_node != null:
		var new_subject: Node3D = awoc_obj.create_awoc_avatar(mesh_list)
		current_preview_node.set_new_subject(new_subject)

*/

