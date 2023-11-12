using Godot;

namespace AWOC
{
	[Tool]
	public partial class HideSlotContainer : BaseCenterPane
	{
		[Export] ConfirmationDialog confirmDeleteDialog; //displayed when the delete button is pressed. Confirms if this hide slot should be deleted
		[Export] Label hideSlotLabel; //the label that shows the name of this hide slot

		public string slotName;	//the name of the Slot this hideSlot belongs to
		public string hideSlotName; //the name of the hide slot that this HideSlotContainer manages

		/// <summary>
		/// Sets the name of this hide slot on both the hide slot label and in the property hideSlotName
		/// </summary>
		/// <param name="slotName">The name of the new hide slot</param>
		/// <returns>void</returns>
		public void SetHideSlotName(string slotName)
		{
			this.hideSlotName = slotName;
			hideSlotLabel.Text = slotName;
		}
	
		public override void _Ready()
		{
			confirmDeleteDialog.Visible = false;
		}

		/// <summary>
		/// Configures the confirmDeleteDialog and then displays it in response to the delete button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_delete_hideslot_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + slotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + slotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
	
		/// <summary>
		/// Deletes this hide slot in response to the confirm button being clicked in confirmDeleteDialog
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_delete_hide_slot_dialog_confirmed()
		{
			awocEditor.awocObj.slotsDictionary[slotName].Remove(hideSlotName);
			awocEditor.SaveCurrentAWOC();
			QueueFree();
		}
	}
}