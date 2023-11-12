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

		//public string awocPath;
		[Export] public AWOCRes awocObj;
		public BaseCenterPane currentPane;
		public BasePreviewPane currentPreviewNode;

		[Export] public string awocPath;

		/// <summary>
		/// This method changes the point's location to
		/// the given coordinates.
		/// </summary>
		/// <param name="preview_pane">the new x-coordinate.</param>
		/// <returns>
		/// void
		/// </returns>
		
		public void SaveCurrentAWOC()
		{
			ResourceSaver.Save(awocObj, awocPath);
		}

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

		void PreviewMaterial(Texture2D texture)
		{
			LoadPreview(materialPreviewPane);
			//currentPreviewNode.SetPreviewTexture(texture);
		}

		void DisableLeftNav(bool disable)
		{
			slotsButton.Disabled = disable;
			meshesButton.Disabled = disable;
			animationsButton.Disabled = disable;
			materialsButton.Disabled = disable;
			recipesButton.Disabled = disable;
			wardrobesButton.Disabled = disable;
		}
		
		public void LoadPane(PackedScene pane)
		{
			if(pane == welcomePane)
			{
				DisableLeftNav(true);
			}
			else
			{
				DisableLeftNav(false);
			}
			
			if(currentPreviewNode != null)
			{
				currentPreviewNode.QueueFree();
			}

			if(currentPane != null)
			{
				currentPane.QueueFree();
			}
				
			currentPane = pane.Instantiate<BaseCenterPane>();
			currentPane.awocEditor = this;
			rightPane.AddChild(currentPane);
		}

		void _on_slots_button_pressed()
		{
			LoadPane(slotsPane);

		}
	
		void _on_meshes_button_pressed()
		{
			LoadPane(meshesPane);
		}

		void _on_materials_button_pressed()
		{
			LoadPane(materialsPane);
		}
	
		void _on_animations_button_pressed()
		{
			LoadPane(animationsPane);
		}
	
		void _on_recipes_button_pressed()
		{
			LoadPane(recipesPane);
		}
	
		void _on_wardrobes_button_pressed()
		{
			LoadPane(wardrobesPane);
		}
	
		void _on_reset_button_pressed()
		{
			LoadPane(welcomePane);
		}
		
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			LoadPane(welcomePane);
		}

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
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

