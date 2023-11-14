using Godot;

namespace AWOC
{
	[Tool]
	public partial class HideSlotContainer : VBoxContainer
	{
		[Signal] public delegate void DeleteEventHandler(string hideSlotName); //In response to the ConfirmDeleteDialog being confirmed, this signal is emitted for SlotContainer to handle
		[Export] ConfirmationDialog confirmDeleteDialog; //displayed when the delete button is pressed. Confirms if this hide slot should be deleted
		[Export] Label hideSlotLabel; //the label that shows the name of this hide slot
		public string hideSlotName; //the name of the hide slot that this HideSlotContainer manages

		/// <summary>
		/// Sets the name of this hide slot on both the hide slot label and in the property hideSlotName
		/// </summary>
		/// <param name="hideSlotName">The name of the new hide slot</param>
		/// <returns>void</returns>
		public void SetHideSlotName(string hideSlotName)
		{
			this.hideSlotName = hideSlotName;
			hideSlotLabel.Text = hideSlotName;
			confirmDeleteDialog.Visible = false;
		}

		/// <summary>
		/// Configures the confirmDeleteDialog and then displays it in response to the delete button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_delete_hideslot_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + hideSlotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + hideSlotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
	
		/// <summary>
		/// Emits the Delete signal and then frees itself
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_delete_hide_slot_dialog_confirmed()
		{
			EmitSignal(SignalName.Delete,hideSlotName);
			QueueFree();
		}
	}
}