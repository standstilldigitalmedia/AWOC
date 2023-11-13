using Godot;

namespace AWOC
{
	[Tool]
	public partial class WelcomePane : BaseCenterPane
	{
		[Export] FileDialog newAWOCDialog;
		[Export] FileDialog loadAWOCDialog;

		void _on_load_awoc_dialog_file_selected(string path)
		{
			AWOCRes tempAWOC = (AWOCRes)GD.Load(path);
			if(tempAWOC is AWOCRes)
			{
				tempAWOC.awocPath = path;
				awocEditor.awocObj = tempAWOC;
				//tempAWOC.LoadSourceAvatar();
				awocEditor.LoadPane(awocEditor.slotsPane);
			}
		}

		void _on_new_awoc_dialog_file_selected(string path)
		{
            awocEditor.awocObj = new AWOCRes(GetFileNameFromPath(path), path)
            {
                awocPath = path
            };
            awocEditor.awocObj.SaveAWOC();
			awocEditor.LoadPane(awocEditor.slotsPane);
		}

		void _on_new_awoc_button_pressed()
		{
			newAWOCDialog.Visible = true;
		}

		void _on_load_awoc_button_pressed()
		{
			loadAWOCDialog.Visible = true;
		}
	

		public override void _Ready()
		{
			InitFileDialog(loadAWOCDialog);
			InitFileDialog(newAWOCDialog);
		}

		public override void InitPane(AWOCEditor awocEditor)
		{
			
		}
	}
}