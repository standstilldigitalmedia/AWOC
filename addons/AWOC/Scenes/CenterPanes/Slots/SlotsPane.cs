using Godot;
using System.Collections.Generic;

namespace AWOC
{
	[Tool]
	public partial class SlotsPane : CenterPaneBase
	{
		[Export] PackedScene slotContainer;//the scene to instantiate for each slot and parent to slotsScrollContainer
		[Export] LineEdit addSlotNameEdit;//Line edit for entering a new slot name
		[Export] VBoxContainer slotsScrollContainer;//The container new SlotContainers will be parented to
		[Export] ConfirmationDialog confirmDuplicateSlotDialog;//Displayed when a slot is being created with the same 
																//name as an exisiting slot. Overwrites the existing 
																//slot if confirmed

		/// <summary>
		/// Fired in response to the save dialog in a SlotContainer emitting the RenameSlot signal, the slotName in
		/// slotToRename is set to slotName and the awocObj is saved to disk.
		/// </summary>
		/// <param name="slotToRename">The slot that is being renamed</param>
		/// <param name="slotName">The new name of the slot</param>
		/// <returns>void</returns>
		void OnRenameSlot(AWOCSlotRes slotToRename, string slotName)
		{
			foreach(AWOCSlotRes slot in awocObj.slots)
			{
				if(slot.slotName == slotToRename.slotName)
				{
					slot.slotName = slotName;
					awocObj.SaveAWOC();
					return;
				}
			}
		}

		/// <summary>
		/// Fired in response to the delete dialog in a SlotContainer emitting the DeleteSlot signal, the slot named
		/// slotToDelete is removed from the slots array in awocObj and the awocObj is saved to disk.
		/// </summary>
		/// <param name="slotToDelete">The name of the slot to be deleted</param>
		/// <returns>void</returns>
		void OnDeleteSlot(AWOCSlotRes slotToDelete)
		{
			awocObj.slots = RemoveElementFromArray(slotToDelete, awocObj.slots);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the delete dialog in a HideSlotContainer emitting the DeleteHideSlot signal, the hideSlot 
		/// named hideSlotName is removed from the hideSlots array in the slotToDeleteFrom and the awocObj is saved 
		/// to disk.
		/// </summary>
		/// <param name="slotToDeleteFrom">The slot where the hideSlot to be deleted is</param>
		/// <param name="hideSlotName">The name of the hideSlot to be deleted</param>
		/// <returns>void</returns>
		void OnDeleteHideSlot(AWOCSlotRes slotToDeleteFrom, string hideSlotName)
		{
			slotToDeleteFrom.hideSlots = RemoveElementFromArray(hideSlotName,slotToDeleteFrom.hideSlots);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the addHideSlot button in a SlotContainer emitting the AddHideSlot signal, the hideSlot 
		/// named hideSlotName is added to the hideSlots array in the slot slotToAddTo and the awocObj is saved 
		/// to disk.
		/// </summary>
		/// <param name="slotToAddTo">The slot where the hideSlot to be added is</param>
		/// <param name="hideSlotName">The name of the hideSlot to be added</param>
		/// <returns>void</returns>
		void OnAddHideSlot(AWOCSlotRes slotToAddTo, string hideSlotName)
		{
			slotToAddTo.hideSlots = AddElementToArray(hideSlotName, slotToAddTo.hideSlots);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the addSlot button in a this pane being pressed, the name of each slot in awocObj
		/// is checked to make sure there are no duplicates and a confirmDuplicateSlotDialog is displayed if a 
		/// duplicate is found. If no duplicate is found, a new AWOCSlotRes is created and added to the awocObj.slots
		/// array. The awoc is then saved and the slots container is repopulated.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_add_slot_button_pressed()
		{ 
			if(addSlotNameEdit.Text.Length > 3 && awocObj != null)
			{
				if(awocObj.slots != null && awocObj.slots.Length > 0)
				{
					foreach(AWOCSlotRes slot in awocObj.slots)
					{
						if(slot.slotName == addSlotNameEdit.Text)
						{
							confirmDuplicateSlotDialog.Title = "Overwrite " + slot.slotName + "?";
							confirmDuplicateSlotDialog.DialogText = "A slot with this name already exists. Would you like to overwrite it?";
							confirmDuplicateSlotDialog.Visible = true;
							return;
						}
					}
				}
				
				AWOCSlotRes newSlot = new AWOCSlotRes(addSlotNameEdit.Text);
				addSlotNameEdit.Text = "";
				awocObj.slots = AddElementToArray(newSlot, awocObj.slots);
				awocObj.SaveAWOC();
				PopulateSlotsContainer();
			}
		}

		/// <summary>
		/// All of the children in slotsScrollContainer are freed before looping through each AWOCSlotRes in awocObj.slots
		/// For each AWOCSlotRes, a dictionary containing the names of all the slots in awocObj.slots is created and used
		/// to initilize a new SlotContainer. Listeners for all of the signals the new SlotConainer will emit are assigned
		/// before adding the new SlotContainer as a child of slotsScrollContainer.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateSlotsContainer()
		{
			if(awocObj != null && awocObj.slots != null && awocObj.slots.Length > 0)
			{
				foreach(SlotContainer child in slotsScrollContainer.GetChildren())
					child.QueueFree();

				foreach(AWOCSlotRes slot in awocObj.slots)
				{
					Dictionary<string,string> slotNameDictionary = new Dictionary<string, string>();
					foreach(AWOCSlotRes innerSlot in awocObj.slots)
					{
						slotNameDictionary.Add(innerSlot.slotName,innerSlot.slotName);
					}
					SlotContainer container = slotContainer.Instantiate<SlotContainer>();
					container.InitSlotContainer(slot, slotNameDictionary);
					container.RenameSlot += OnRenameSlot;
					container.DeleteSlot += OnDeleteSlot;
					container.DeleteHideSlot += OnDeleteHideSlot;
					container.AddHideSlot += OnAddHideSlot;
					slotsScrollContainer.AddChild(container);
				}
			}
		}

		/// <summary>
		/// In response to the confirmDuplicateSlotDialog being confirmed, the slot with the same name as the text in 
		/// addSlotNameEdit.Text has its hideSlots array set to null and awocObj is saved to disk.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_duplicate_slot_dialog_confirmed()
		{
			foreach(AWOCSlotRes slot in awocObj.slots)
			{
				if(slot.slotName == addSlotNameEdit.Text)
				{
					slot.hideSlots = null;
					awocObj.SaveAWOC();
					return;
				}
			}
		}

		/// <summary>
		/// Overridden from CenterPaneBase, awocEditor and awocObj are set and SlotsContainer is populated 
		/// </summary>
		/// <param name="awocEditor">The main controller for the AWOC editor window</param>
		/// <returns>void</returns>
		public override void InitPane(AWOCEditor awocEditor)
		{
			this.awocEditor = awocEditor;
			awocObj = awocEditor.awocObj;
			PopulateSlotsContainer();
		}
	}
}