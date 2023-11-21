using Godot;
using Microsoft.VisualBasic;

namespace AWOC
{
	[Tool]
	public partial class OverlayContainer : VBoxContainer
	{
		[Export] HBoxContainer overlayControlsContainer;
		[Export] VBoxContainer overlayPropertiesContainer;

		[Export] Button showOverlayPropertiesButton;
		[Export] Button hideOverlayPropertiesButton;
		void _on_overlay_button_toggled(bool toggled)
		{
			if(toggled)
			{
				overlayControlsContainer.Visible = true;
			}
			else
			{
				overlayControlsContainer.Visible = false;
				overlayPropertiesContainer.Visible = false;
			}
		}

		void _on_show_overylay_properties_button_pressed()
		{
			showOverlayPropertiesButton.Visible = false;
			hideOverlayPropertiesButton.Visible = true;
			overlayPropertiesContainer.Visible = true;
		}

		void _on_hide_overlay_properties_button_pressed()
		{
			showOverlayPropertiesButton.Visible = true;
			hideOverlayPropertiesButton.Visible = false;
			overlayPropertiesContainer.Visible = false;
		}
	}
}


