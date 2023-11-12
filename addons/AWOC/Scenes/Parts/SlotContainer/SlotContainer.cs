using Godot;
using Godot.Collections;

namespace AWOC
{
	[Tool]
	public partial class SlotContainer : BaseCenterPane
	{
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

		string slotName; //the name of the slot that this SlotContainer manages

		/// <summary>
		/// Loops through all the keys in awocEditor.awocObj.slotsDictionary and adds them as options to the OptionButton named hideSlotSelect
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateHideSlotSelect()
		{
			if(awocEditor != null && awocEditor.awocObj != null)
			{
				//clear all of the previous options before adding more
				hideSlotSelect.Clear();
				//get the names of the slots in awocEditor.awocObj.slotsDictionary
				var keys = awocEditor.awocObj.slotsDictionary.Keys;
				//loop through each of the slot names
				foreach(string key in keys)
				{
					//A slot can't hide itself so only add the option if key is anything besides this slot's name
					if(key != slotName)
					{
						hideSlotSelect.AddItem(key);
					}
				}
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
			if(awocEditor != null && awocEditor.awocObj != null)
			{
				//get rid of all of HideSlotScrollContainer's children before adding more
				foreach(HideSlotContainer child in hideSlotScrollContainer.GetChildren())
				{
					child.QueueFree();
				}
				//get the names of all the hide slots in the slot this SlotContainer manages
				var keys = awocEditor.awocObj.slotsDictionary[slotName].Keys;
				//loop through each of the keys
				foreach(string hideSlot in keys)
				{
					//instantiate a new HideSlotContainer
					HideSlotContainer newHideSlot = hideSlotContainerScene.Instantiate<HideSlotContainer>();
					//assign the AWOCEditor assigned to this slot to the new HideSlotContainer
					newHideSlot.awocEditor = awocEditor;
					//set the new HideSlotContainer's slotName to the name of this slot
					newHideSlot.slotName = slotName;
					//set the new HideSlotContainer's hide slot name
					newHideSlot.SetHideSlotName(hideSlot);
					//parent the new HideSlotContainer to hideSlotScrollContainer
					hideSlotScrollContainer.AddChild(newHideSlot);
				}
			}
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

		/// <summary>
		/// Sets the name of this slot on the slot label, in the property slotName, and the text of the slotNameEdit LineEdit
		/// and then populates hideSlotContainer with HideSlotContainers
		/// </summary>
		/// <param name="slotName">The name to be displayed in the label text, the slotNameEdit text, and to be assigned to slotName</param>
		/// <returns>void</returns>
		public void SetSlotName(string slotName)
		{
			this.slotName = slotName;
			slotButton.Text = slotName;
			slotNameEdit.Text = slotName;
			PopulateHideSlotContainer();
		}
	
		public override void _Ready()
		{
			ShowControls(false);
			confirmSaveDialog.Visible = false;
			confirmDeleteDialog.Visible = false;
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
		/// Creates a new entry in awocEditor.awocObj.slotsDictionary with a key that is the value of slotNameEdit's text
		/// and assigns the hide slots of the old slot to the new one. The old slot is removed from the dictionary, the name
		/// of this SlotContainer is set, and the current AWOC is saved
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confrim_save_dialog_confirmed()
		{
			string newName = slotNameEdit.Text;
			awocEditor.awocObj.slotsDictionary[newName] = awocEditor.awocObj.slotsDictionary[slotName];
			awocEditor.awocObj.slotsDictionary.Remove(slotName);
			SetSlotName(newName);
			awocEditor.SaveCurrentAWOC();
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
		/// Deletes the slot this SlotContainer manages from awocEditor.awocObj.slotsDictionary in response to confirmDeleteDialog being confirmed
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_delete_dialog_confirmed()
		{
			awocEditor.awocObj.slotsDictionary.Remove(slotName);
			QueueFree();
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
	
		void _on_add_hide_slot_button_pressed()
		{
			string newHideSlot = hideSlotSelect.GetItemText(hideSlotSelect.GetSelectedId());
			if(newHideSlot != null && newHideSlot.Length > 1)
			{
				var keys = awocEditor.awocObj.slotsDictionary[slotName].Keys;
				foreach(string hideSlot in keys)
				{
					if(hideSlot == newHideSlot)
						return;
				}
				awocEditor.awocObj.slotsDictionary[slotName][newHideSlot] = newHideSlot;
				PopulateHideSlotContainer();
				awocEditor.SaveCurrentAWOC();
			}
				
		}
	}
}