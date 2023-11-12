using Godot;

namespace AWOC
{
	[Tool]
	public partial class HideSlotContainer : BaseCenterPane
	{
		[Export] ConfirmationDialog confirmDeleteDialog; 
		[Export] Label hideSlotLabel;

		public string slotName;
		public string hideSlotName;

		public void SetHideSlotName(string slotName)
		{
			this.hideSlotName = slotName;
			hideSlotLabel.Text = slotName;
		}
	

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			confirmDeleteDialog.Visible = false;
		}

		void _on_delete_hideslot_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + slotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + slotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
	
		void _on_confirm_delete_hide_slot_dialog_confirmed()
		{
			awocEditor.awocObj.slotsDictionary[slotName].Remove(hideSlotName);
			awocEditor.SaveCurrentAWOC();
			QueueFree();
		}
	
	}
}