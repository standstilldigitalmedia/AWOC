using Godot;
using System.Collections.Generic;

namespace AWOC
{
	[Tool]
	public partial class SlotContainer : VBoxContainer
	{
		[Signal] public delegate void RenameSlotEventHandler(AWOCSlot oldSlot, string newSlotName);
		[Signal] public delegate void DeleteSlotEventHandler(AWOCSlot slotToDelete);
		[Signal] public delegate void DeleteHideSlotEventHandler(string slotName, string hideSlotName);
		[Signal] public delegate void AddHideSlotEventHandler(AWOCSlot slotToAddTo, string hideSlotName);
		
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

		AWOCSlot awocSlot; //the name of the slot that this SlotContainer manages
		Dictionary<string,string> slotNameDictionary;
		List<string> hideSlotList;

		/// <summary>
		/// Loops through all the keys in awocEditor.awocObj.slotsDictionary and adds them as options to the OptionButton named hideSlotSelect
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateHideSlotSelect()
		{
			if(slotNameDictionary != null)
			{
				//clear all of the previous options before adding more
				hideSlotSelect.Clear();
				var keys = slotNameDictionary.Keys;
				bool itemAdded = false;
				bool hideSlotFound = false;
				foreach(string slot in keys)
				{
					foreach(string hideSlot in hideSlotList)
					{
						if(hideSlot == slot)
							hideSlotFound = true;
					}
					if(!hideSlotFound && slot != awocSlot.slotName)
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
			if(hideSlotList != null)
			{
				//get rid of all of HideSlotScrollContainer's children before adding more
				foreach(HideSlotContainer child in hideSlotScrollContainer.GetChildren())
				{
					child.QueueFree();
				}

				foreach(string hideSlot in hideSlotList)
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
		public void SetSlotName(AWOCSlot awocSlot)
		{
			this.awocSlot = awocSlot;
			slotButton.Text = awocSlot.slotName;
			slotNameEdit.Text = awocSlot.slotName;
		}

		public void InitSlotContainer(AWOCSlot awocSlot, Dictionary<string, string> sourceSlotNameDictionary, string[] hideSlotArray)
		{
			SetSlotName(awocSlot);
			slotNameDictionary = sourceSlotNameDictionary;
			hideSlotList = new List<string>();

			if(hideSlotArray != null)
				foreach(string slot in hideSlotArray)
					if(awocSlot.slotName != slot)
						hideSlotList.Add(slot);
			
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
			if(!slotNameDictionary.ContainsKey(deleteSlotName))
				slotNameDictionary.Add(deleteSlotName, deleteSlotName);

			hideSlotList.Remove(deleteSlotName);
			PopulateHideSlotSelect();

			EmitSignal(SignalName.DeleteHideSlot,awocSlot.slotName,deleteSlotName);
		}
	
		void _on_add_hide_slot_button_pressed()
		{
			string selectedSlot = hideSlotSelect.GetItemText(hideSlotSelect.GetSelectedId());
			hideSlotList.Add(selectedSlot);
			if(slotNameDictionary.ContainsKey(selectedSlot))
				slotNameDictionary.Remove(selectedSlot);
			PopulateHideSlotContainer();
			PopulateHideSlotSelect();
			EmitSignal(SignalName.AddHideSlot,awocSlot,selectedSlot);
		}
	}
}