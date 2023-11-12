using Godot;
using Godot.Collections;

namespace AWOC
{
	[Tool]
	public partial class SlotContainer : BaseCenterPane
	{
		[Export] HBoxContainer slotControlsContainer;
		[Export] ColorRect hideSlotContainer;
		[Export] Button slotButton;
		[Export] LineEdit slotNameEdit;
		[Export] ConfirmationDialog confirmSaveDialog;
		[Export] ConfirmationDialog confirmDeleteDialog;
		[Export] Button showButton;
		[Export] Button hideButton;
		[Export] OptionButton hideSlotSelect;
		[Export] VBoxContainer hideSlotScrollContainer;
		[Export] PackedScene hideSlotContainerScene;

		string slotName;

		void PopulateHideSlotSelect()
		{
			if(awocEditor != null && awocEditor.awocObj != null)
			{
				hideSlotSelect.Clear();
				var keys = awocEditor.awocObj.slotsDictionary.Keys;
				foreach(string key in keys)
				{
					//slot.Value
					if(key != slotName)
					{
						hideSlotSelect.AddItem(key);
					}
				}
			}
		}

		void SetHideSlotName1(string hideSlotName, HideSlotContainer hideSlot)
		{
			hideSlot.SetHideSlotName(hideSlotName);
		}

		void PopulateHideSlotContainer()
		{
			if(awocEditor != null && awocEditor.awocObj != null)
			{
				foreach(HideSlotContainer child in hideSlotScrollContainer.GetChildren())
				{
					child.QueueFree();
				}
				var keys = awocEditor.awocObj.slotsDictionary[slotName].Keys;
				foreach(string hideSlot in keys)
				{
					HideSlotContainer newHideSlot = hideSlotContainerScene.Instantiate<HideSlotContainer>();
					newHideSlot.awocEditor = awocEditor;
					newHideSlot.slotName = slotName;
					newHideSlot.SetHideSlotName(hideSlot);
					hideSlotScrollContainer.AddChild(newHideSlot);
				}
			}
		}

		void ShowControls(bool show)
		{
			slotControlsContainer.Visible = show;
			hideSlotContainer.Visible = show;
		}

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

		void _on_slot_button_toggled(bool buttonPressed)
		{
			slotControlsContainer.Visible = buttonPressed;
			hideSlotContainer.Visible = false;
			showButton.Visible = true;
			hideButton.Visible = false;
		}

		void _on_save_button_pressed()
		{
			confirmSaveDialog.Title = "Rename " + slotName + "?";
			confirmSaveDialog.DialogText = "Are you sure you wish to rename " + slotName + "? This can not be undone.";
			confirmSaveDialog.Visible = true;
		}

		void _on_confrim_save_dialog_confirmed()
		{
			string newName = slotNameEdit.Text;
			awocEditor.awocObj.slotsDictionary[newName] = awocEditor.awocObj.slotsDictionary[slotName];
			awocEditor.awocObj.slotsDictionary.Remove(slotName);
			SetSlotName(newName);
			awocEditor.SaveCurrentAWOC();
		}

		void _on_delete_button_pressed()
		{
			confirmDeleteDialog.Title = "Delete " + slotName + "?";
			confirmDeleteDialog.DialogText = "Are you sure you wish to delete " + slotName + "? This can not be undone.";
			confirmDeleteDialog.Visible = true;
		}
			
		void _on_confirm_delete_dialog_confirmed()
		{
			awocEditor.awocObj.slotsDictionary.Remove(slotName);
			QueueFree();
		}

		void _on_show_button_pressed()
		{
			showButton.Visible = false;
			hideButton.Visible = true;
			hideSlotContainer.Visible = true;
			PopulateHideSlotSelect();
		}
	
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