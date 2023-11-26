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
		public CenterPaneBase currentPane;
		public BasePreviewPane currentPreviewNode;

		/// <summary>
		/// Frees the currentPreviewNode and then adds the previewPane specified
		/// in the paramater previewPane to the right side pane
		/// </summary>
		/// <param name="previewPane">The preview pane to be added to the right side of the AWOC editor window</param>
		/// <returns>void</returns>
		public void LoadPreview(BasePreviewPane previewPane)
		{
			
			currentPreviewNode = null;
			currentPreviewNode = previewPane;
			mainContainer.AddChild(currentPreviewNode);
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

			if(currentPreviewNode != null)
				currentPreviewNode.QueueFree();
			currentPreviewNode = null;

			if(currentPane != null)
				currentPane.QueueFree();

			//now that all the old stuff has been freed, the new pane can be instantiated and parented to the right pane	
			currentPane = pane.Instantiate<CenterPaneBase>();
			currentPane.InitPane(this);
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