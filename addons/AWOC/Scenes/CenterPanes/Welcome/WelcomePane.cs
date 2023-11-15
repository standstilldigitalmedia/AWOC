using Godot;

namespace AWOC
{
	[Tool]
	public partial class WelcomePane : CenterPaneBase
	{
		[Export] FileDialog newAWOCDialog;//Displayed in response to the NewAWOC button being pressed, gets the path for a
											//new AWOC
		[Export] FileDialog loadAWOCDialog;//Displayed in response to the LoadAWOC button being pressed, gets the path for 
											//an existing AWOC to be loaded

		/// <summary>
		/// In response to a resource file being selected, the file is loaded and checked to make sure it is a AWOCRes file
		/// If the file is a AWOCRes file, awocPath is set to the path of the loaded file in the loaded AWOC. awocObj in 
		/// awocEditor is set to the loaded AWOC. Finally, slots pane is loaded.
		/// </summary>
		/// <param name="path">The path selected in loadAWOCDialog</param>
		/// <returns>void</returns>
		void _on_load_awoc_dialog_file_selected(string path)
		{
			AWOCRes tempAWOC = (AWOCRes)GD.Load(path);
			if(tempAWOC is AWOCRes)
			{
				tempAWOC.awocPath = path;
				awocEditor.awocObj = tempAWOC;
				awocEditor.LoadPane(awocEditor.slotsPane);
			}
		}

		/// <summary>
		/// In response to a file path being selected in newAWOCDialog, a new AWOCRes is created and its awocPath is set
		/// to the path selected in the newAWOCDialog. The new AWOC is saved to disk and then SlotsPane is loaded.
		/// </summary>
		/// <param name="path">The path selected in newAWOCDialog</param>
		/// <returns>void</returns>
		void _on_new_awoc_dialog_file_selected(string path)
		{
            awocObj = new AWOCRes(AWOCHelper.GetFileNameFromPath(path), path)
            {
                awocPath = path
            };
            awocObj.SaveAWOC();
			awocEditor.awocObj = awocObj;
			awocEditor.LoadPane(awocEditor.slotsPane);
		}

		/// <summary>
		/// In response to NewAWOCButton being pressed, the newAWOCDialog is displayed.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_new_awoc_button_pressed()
		{
			newAWOCDialog.Visible = true;
		}

		/// <summary>
		/// In response to LoadAWOCButton being pressed, the loadAWOCDialog is displayed.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_load_awoc_button_pressed()
		{
			loadAWOCDialog.Visible = true;
		}

		/// <summary>
		/// Overridden from CenterPaneBase, awocEditor and awocObj are set and file dialogs are initilized
		/// </summary>
		/// <param name="awocEditor">The main controller for the AWOC editor window</param>
		/// <returns>void</returns>
		public override void InitPane(AWOCEditor awocEditor)
		{
			this.awocEditor = awocEditor;
			AWOCHelper.InitFileDialog(loadAWOCDialog);
			AWOCHelper.InitFileDialog(newAWOCDialog);
		}
	}
}