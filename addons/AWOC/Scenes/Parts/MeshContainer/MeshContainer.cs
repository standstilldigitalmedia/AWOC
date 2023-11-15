using Godot;

namespace AWOC
{
	[Tool]
	public partial class MeshContainer : HBoxContainer
	{
		[Signal] public delegate void ShowMeshEventHandler(string meshName, bool show);
		[Export] Label meshLabel;
		[Export] Button showButton;
		[Export] Button hideButton;
		string meshName;

		public void SetMeshName(string meshName)
		{
			this.meshName = meshName;
			meshLabel.Text = meshName;
		}

		void _on_show_button_pressed()
		{
			hideButton.Visible = true;
			showButton.Visible = false;
			EmitSignal(SignalName.ShowMesh,meshName,true);
		}

		void _on_hide_button_pressed()
		{
			hideButton.Visible = false;
			showButton.Visible = true;
			EmitSignal(SignalName.ShowMesh,meshName,false);
		}
	}
}