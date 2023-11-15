using Godot;
using System.Collections.Generic;

namespace AWOC
{
	[Tool]
	public partial class SlotContainer : Node
	{
		[Signal] public delegate void RenameSlotEventHandler(string slotToRename, string slotName); //In response to the save button being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void DeleteSlotEventHandler(string slotToDelete);//In response to the delete button being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void DeleteHideSlotEventHandler(string slotToDeleteFrom, string hideSlotToDelete);//In response to the delete button on a hide slot being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void AddHideSlotEventHandler(string slotToAddTo, string hideSlotToAdd);//In response to the AddHideSlotButton being pressed, this signal is emitted for SlotsPane to handle
		
		[Export] HBoxContainer slotControlsContainer; //the container that holds the slotNameEdit, save button, delete button, and show and hide buttons
		[Export] ColorRect hideSlotContainer; //the container that holds the hideSlotControls. It is hidden or shown when the show and hide buttons are pressed
		[Export] Button slotButton; //the main slot button that hides and shows the slotControlsContainer
		[Export] LineEdit slotNameEdit; //a line edit for changing the slot name
		[Export] ConfirmationDialog confirmSaveDialog; //displayed when the save button is pressed. If confirmed, the new slot name is saved
		[Export] ConfirmationDialog confirmDeleteDialog; //displayed when the delete button is pressed. If confirmed, the new slot is deleted
		[Export] Button showButton; //when clicked, hides itself and shows hideButton and also shows hideSlotContainer
		[Export] Button hideButton; //when clicked, hides itself and shows showButton and also hides hideSlotContainer
		[Export] OptionButton hideSlotSelect; //each option is slot you can have hidden when this slot is equipped
		[Export] VBoxContainer hideSlotScrollContainer; //the container that holds all the hide slot controls
		[Export] PackedScene hideSlotContainerScene; //the scene to instantiate for each hide slot and parent to hideSlotScrollContainer

		string slotName; //The AWOCSlot this container managages
		Dictionary<string,string> availableSlotsToHide;//
		//List<string> allSlotsList;
		string[] hideSlotsArray;

		/// <summary>
		/// Shows or hides the main controls for this slot based on the value of the parameter named show
		/// </summary>
		/// <param name="show">A boolean used to set the visibility of this slot's main controls</param>
		/// <returns>void</returns>
		void ShowControls(bool show)
		{
			slotControlsContainer.Visible = show;
			hideSlotContainer.Visible = show;
		}

		/// <summary>
		/// Clears hideSlotSelect and then loops through all of the keys in avaliableSlotsToHide and adds them to the 
		/// hideSlotSelect option button. Finally, the first option in hideSlotSelect is selected
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateHideSlotSelect()
		{
			if(availableSlotsToHide != null)
			{
				hideSlotSelect.Clear();
				Dictionary<string, string>.KeyCollection keys = availableSlotsToHide.Keys;
				foreach(string slot in keys)
				{
					if(slot != slotName)
					{
						hideSlotSelect.AddItem(slot);
					}
				}
				if(hideSlotSelect.ItemCount > 0)
					hideSlotSelect.Select(0);
			}
		}

		/// <summary>
		/// Frees all children of hideSlotScrollContainer and then loops through all the hide slots in 
		/// hideSlotsArray and spawns a HideSlotContainer and parents it to hideSlotScrollContainer
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateHideSlotContainer()
		{
			if(hideSlotsArray != null)
			{
				//get rid of all of HideSlotScrollContainer's children before adding more
				foreach(HideSlotContainer child in hideSlotScrollContainer.GetChildren())
				{
					child.QueueFree();
				}

				foreach(string hideSlot in hideSlotsArray)
				{
					//instantiate a new HideSlotContainer
					HideSlotContainer newHideSlot = hideSlotContainerScene.Instantiate<HideSlotContainer>();
					
					newHideSlot.Delete += OnDeleteHideSlot;
					//set the new HideSlotContainer's hide slot name
					newHideSlot.SetHideSlotName(hideSlot);
					//parent the new HideSlotContainer to hideSlotScrollContainer
					hideSlotScrollContainer.AddChild(newHideSlot);
				}
			}
		}

		/// <summary>
		/// Sets awocSlot for this slot, and sets the text of slotButton and slotNameEdit to this slot's slotName
		/// </summary>
		/// <param name="awocSlot">The AWOCSlot this container will manage</param>
		/// <returns>void</returns>
		void SetSlotName(string slotName)
		{
			this.slotName = slotName;
			slotButton.Text = slotName;
			slotNameEdit.Text = slotName;
		}

		/// <summary>
		/// Loops through all the keys in availableSlotsToHide and all the strings in hideSlotsArray, looking for matches.
		/// If a match is found, it is removed from availableSlotsToHide
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void InitavailableSlotsToHide()
		{
			if(availableSlotsToHide != null && hideSlotsArray != null)
			{
				Dictionary<string,string>.KeyCollection keys = availableSlotsToHide.Keys;
				foreach(string avaliableSlot in keys)
				{
					foreach(string hideSlot in hideSlotsArray)
					{
						if(avaliableSlot == hideSlot || avaliableSlot == slotName)
							availableSlotsToHide.Remove(hideSlot);
					}
				}
			}
		}

		/// <summary>
		/// Takes care of initilizing this SlotContainer with the paramaters provided
		/// </summary>
		/// <param name="awocSlot">The AWOCSlot this SlotContainer will manage</param>
		/// <param name="availableSlotsToHide">All of the slots in this AWOC except for the slot in awocSlot</param>
		/// <returns>void</returns>
		public void InitSlotContainer(AWOCSlotContainerRes awocSlotContainerRes, Dictionary<string, string> availableSlotsToHide)
		{
			this.availableSlotsToHide = availableSlotsToHide;
			hideSlotsArray = awocSlotContainerRes.hideSlots;

			confirmSaveDialog.Visible = false;
			confirmDeleteDialog.Visible = false;

			ShowControls(false);
			InitavailableSlotsToHide();
			SetSlotName(awocSlotContainerRes.slotName);			
			PopulateHideSlotSelect();
			PopulateHideSlotContainer();
		}

		/// <summary>
		/// Hides showButton, shows hideButton, shows hideSlotContainer and populates hideSlotSelect with all 
		/// of this slot's hide slots in response to showButton being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_show_button_pressed()
		{
			showButton.Visible = false;
			hideButton.Visible = true;
			hideSlotContainer.Visible = true;
			PopulateHideSlotSelect();
		}
	
		/// <summary>
		/// Shows showButton, hides hideButton, and hides hideSlotContainer
		/// in response to hideButton being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_hide_button_pressed()
		{
			showButton.Visible = true;
			hideButton.Visible = false;
			hideSlotContainer.Visible = false;
		}

		/// <summary>
		/// Shows or hides this slot's main controls and hide slot controls in response to the main slot button
		/// being pressed. Also shows showButton and hides hideButton
		/// </summary>
		/// <param name="buttonPressed">A boolean representing whether the button was toggled on or toggled off</param>
		/// <returns>void</returns>
		void _on_slot_button_toggled(bool buttonPressed)
		{
			slotControlsContainer.Visible = buttonPressed;
			hideSlotContainer.Visible = false;
			showButton.Visible = true;
			hideButton.Visible = false;
		}

		/// <summary>
		/// Congfigures confirmSaveDialog and then displays it in response to the save button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_save_button_pressed()
		{
			confirmSaveDialog.Title = "Rename " + slotName + "?";
			confirmSaveDialog.DialogText = "Are you sure you wish to rename " + slotName + "? This can not be undone.";
			confirmSaveDialog.Visible = true;
		}

		/// <summary>
		/// Congfigures confirmDeleteDialog and then displays it in response to the delete button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_delete_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + slotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + slotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
			
		/// <summary>
		/// Emits the Delete signal for SlotPane to handle and then frees itself in response to confirmDeleteDialog
		/// being confirmed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_delete_dialog_confirmed()
		{
			EmitSignal(SignalName.DeleteSlot,slotName);
			QueueFree();
		}

		/// <summary>
		/// Emits the RenameSlot signal for SlotPane to handle, sets the new name in awocSlot.slotName, 
		/// and calls SetSlot to set the label text and edit text in response to the save button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confrim_save_dialog_confirmed()
		{
			EmitSignal(SignalName.RenameSlot,slotName,slotNameEdit.Text);
			SetSlotName(slotNameEdit.Text);
		}

		/// <summary>
		/// Adds the paramater deleteSlotName to availableSlotsToHide, removes deleteSlotName from hideSlotsArray,
		/// populates the HideSlotSelect option button, and emits the DeleteHideSlot signal for SlotsPane to handle
		/// in response to HideSlotContainer emitting the Delete signal
		/// </summary>
		/// <param name="deleteSlotName">The name of the hide slot to remove</param>
		/// <returns>void</returns>
		void OnDeleteHideSlot(string deleteSlotName)
		{
			if(!availableSlotsToHide.ContainsKey(deleteSlotName))
				availableSlotsToHide.Add(deleteSlotName, deleteSlotName);

			hideSlotsArray = AWOCHelper.RemoveElementFromArray(deleteSlotName, hideSlotsArray);
			PopulateHideSlotSelect();
			EmitSignal(SignalName.DeleteHideSlot,slotName,deleteSlotName);
		}
	
		/// <summary>
		/// Adds the selected slot name in hideSlotSelect to hideSlotsArray, removes the slot name in hideSlotSelect from
		/// availableSlotsToHide, populates the HideSlotContainer and HideSlotSelect and then emits the AddHideSlot signal
		/// for SlotPane to handle
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_add_hide_slot_button_pressed()
		{
			string selectedSlot = hideSlotSelect.GetItemText(hideSlotSelect.GetSelectedId());
			hideSlotsArray = AWOCHelper.AddElementToArray(selectedSlot,hideSlotsArray);
			if(availableSlotsToHide.ContainsKey(selectedSlot))
				availableSlotsToHide.Remove(selectedSlot);
			PopulateHideSlotContainer();
			PopulateHideSlotSelect();
			EmitSignal(SignalName.AddHideSlot,slotName,selectedSlot);
		}
	}
}