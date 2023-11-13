using Godot;
using System.Collections.Generic;

namespace AWOC
{
	[Tool]
	public partial class SlotContainer : PaneBase
	{
		[Signal] public delegate void RenameSlotEventHandler(AWOCSlotRes oldSlot, string newSlotName); //In response to the save button being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void DeleteSlotEventHandler(AWOCSlotRes slotToDelete);//In response to the delete button being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void DeleteHideSlotEventHandler(string slotName, string hideSlotName);//In response to the delete button on a hide slot being pressed, this signal is emitted for SlotsPane to handle
		[Signal] public delegate void AddHideSlotEventHandler(AWOCSlotRes slotToAddTo, string hideSlotName);//In response to the AddHideSlotButton being pressed, this signal is emitted for SlotsPane to handle
		
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

		AWOCSlotRes awocSlot; //The AWOCSlot this container managages
		Dictionary<string,string> avaliableSlotsToHide;//
		//List<string> allSlotsList;
		string[] hideSlotsArray;

		/// <summary>
		/// Loops through all the keys in awocEditor.awocObj.slotsDictionary and adds them as options to the OptionButton named hideSlotSelect
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateHideSlotSelect()
		{
			if(avaliableSlotsToHide != null)
			{
				//clear all of the previous options before adding more
				hideSlotSelect.Clear();
				var keys = avaliableSlotsToHide.Keys;
				bool itemAdded = false;
				foreach(string slot in keys)
				{
					if(slot != awocSlot.slotName)
					{
						hideSlotSelect.AddItem(slot);
						itemAdded = true;
					}
				}
				if(itemAdded)
					hideSlotSelect.Select(0);
			}
		}

		/// <summary>
		/// Loops through all the hide slots in the slot this SlotContainer manages and spawns a HideSlotContainer and parents
		/// it to hideSlotScrollContainer
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
		/// Sets the name of this slot on the slot label, in the property slotName, and the text of the slotNameEdit LineEdit
		/// </summary>
		/// <param name="slotName">The name to be displayed in the label text, the slotNameEdit text, and to be assigned to slotName</param>
		/// <returns>void</returns>
		public void SetSlotName(AWOCSlotRes awocSlot)
		{
			this.awocSlot = awocSlot;
			slotButton.Text = awocSlot.slotName;
			slotNameEdit.Text = awocSlot.slotName;
		}

		public void InitSlotContainer(AWOCSlotRes awocSlot, Dictionary<string, string> avaliableSlotsToHide, string[] hideSlotArray)
		{
			this.avaliableSlotsToHide = avaliableSlotsToHide;
			this.hideSlotsArray = hideSlotArray;
			if(avaliableSlotsToHide != null && hideSlotsArray != null)
			{
				Dictionary<string,string>.KeyCollection keys = avaliableSlotsToHide.Keys;
				foreach(string avaliableSlot in keys)
				{
					foreach(string hideSlot in hideSlotArray)
					{
						if(avaliableSlot == hideSlot)
							avaliableSlotsToHide.Remove(hideSlot);
					}
				}
			}
			//allSlotsList = new List<string>();

			/*if(avaliableSlotsToHide != null)
			{
				Dictionary<string, string>.KeyCollection keys = avaliableSlotsToHide.Keys;
				foreach(string slot in keys)
					allSlotsList.Append(slot);
			}*/
			
			SetSlotName(awocSlot);			
			PopulateHideSlotSelect();
			PopulateHideSlotContainer();
		}

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
	
		public override void _Ready()
		{
			ShowControls(false);
			confirmSaveDialog.Visible = false;
			confirmDeleteDialog.Visible = false;
		}

		/// <summary>
		/// Hides showButton, shows hideButton, shows hideSlotContainer and populates hideSlotSelect with all of this slot's hide slots
		/// in response to showButton being pressed
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
			confirmSaveDialog.Title = "Rename " + awocSlot.slotName + "?";
			confirmSaveDialog.DialogText = "Are you sure you wish to rename " + awocSlot.slotName + "? This can not be undone.";
			confirmSaveDialog.Visible = true;
		}

		/// <summary>
		/// Congfigures confirmDeleteDialog and then displays it in response to the delete button being pressed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_delete_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + awocSlot.slotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + awocSlot.slotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
			
		/// <summary>
		/// Deletes the slot this SlotContainer manages from awocEditor.awocObj.slotsDictionary in response to confirmDeleteDialog being confirmed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_delete_dialog_confirmed()
		{
			EmitSignal(SignalName.DeleteSlot,awocSlot);
			QueueFree();
		}

		void _on_confrim_save_dialog_confirmed()
		{
			EmitSignal(SignalName.RenameSlot,awocSlot,slotNameEdit.Text);
			awocSlot.slotName = slotNameEdit.Text;
			SetSlotName(awocSlot);
		}

		void OnDeleteHideSlot(string deleteSlotName)
		{
			if(!avaliableSlotsToHide.ContainsKey(deleteSlotName))
				avaliableSlotsToHide.Add(deleteSlotName, deleteSlotName);

			hideSlotsArray = RemoveElementFromArray(deleteSlotName, hideSlotsArray);
			PopulateHideSlotSelect();

			EmitSignal(SignalName.DeleteHideSlot,awocSlot.slotName,deleteSlotName);
		}
	
		void _on_add_hide_slot_button_pressed()
		{
			string selectedSlot = hideSlotSelect.GetItemText(hideSlotSelect.GetSelectedId());
			hideSlotsArray = AddElementToArray(selectedSlot,hideSlotsArray);
			if(avaliableSlotsToHide.ContainsKey(selectedSlot))
				avaliableSlotsToHide.Remove(selectedSlot);
			PopulateHideSlotContainer();
			PopulateHideSlotSelect();
			EmitSignal(SignalName.AddHideSlot,awocSlot,selectedSlot);
		}
	}
}