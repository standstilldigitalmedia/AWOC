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
		/// Fired in response to the confirmSaveDialog in a SlotContainer emitting the RenameSlot signal, calls 
		/// awocObj.awocSlotsRes.RenameSlot(slotToRename, slotName) and then saves the AWOC to disk.
		/// </summary>
		/// <param name="slotToRename">The name of the slot to be renamed</param>
		/// <param name="slotName">The new name of the slot</param>
		/// <returns>void</returns>
		void OnRenameSlot(string slotToRename, string slotName)
		{
			awocObj.awocSlotsRes.RenameSlot(slotToRename, slotName);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the delete dialog in a SlotContainer emitting the DeleteSlot signal, calls
		/// awocObj.awocSlotsRes.DeleteSlot(slotToDelete) and then saves the AWOC to disk
		/// </summary>
		/// <param name="slotToDelete">The name of the slot to be deleted</param>
		/// <returns>void</returns>
		void OnDeleteSlot(string slotToDelete)
		{
			awocObj.awocSlotsRes.DeleteSlot(slotToDelete);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the delete dialog in a HideSlotContainer emitting the DeleteHideSlot signal, calls 
		/// awocObj.awocSlotsRes.DeleteHideSlot(slotToDeleteFrom,hideSlotName); and then saves the AWOC to disk
		/// to disk.
		/// </summary>
		/// <param name="slotToDeleteFrom">The slot where the hideSlot to be deleted is</param>
		/// <param name="hideSlotName">The name of the hideSlot to be deleted</param>
		/// <returns>void</returns>
		void OnDeleteHideSlot(string slotToDeleteFrom, string hideSlotName)
		{
			awocObj.awocSlotsRes.DeleteHideSlot(slotToDeleteFrom,hideSlotName);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the addHideSlot button in a SlotContainer emitting the AddHideSlot signal, calls
		/// awocObj.awocSlotsRes.AddHideSlot(slotToAddTo,hideSlotName) and then saves the AWOC to disk
		/// </summary>
		/// <param name="slotToAddTo">The slot where the hideSlot to be added is</param>
		/// <param name="hideSlotName">The name of the hideSlot to be added</param>
		/// <returns>void</returns>
		void OnAddHideSlot(string slotToAddTo, string hideSlotName)
		{
			awocObj.awocSlotsRes.AddHideSlot(slotToAddTo,hideSlotName);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Fired in response to the addSlot button in a this pane being pressed, if the name being added is
		/// the same as another slot, a confirmDuplicateSlotDialog is displayed to confirm overwriting the existing slot.
		/// If no duplicate is found, a new AWOCSlotRes is created and added to the awocObj.AWOCSlotsRes
		/// array. The awoc is then saved and the slots container is repopulated.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_add_slot_button_pressed()
		{ 
			if(addSlotNameEdit.Text.Length > 3 && awocObj != null)
			{
				if(awocObj.awocSlotsRes.SlotExists(addSlotNameEdit.Text))
				{
					confirmDuplicateSlotDialog.Title = "Overwrite " + addSlotNameEdit.Text + "?";
					confirmDuplicateSlotDialog.DialogText = "A slot with this name already exists. Would you like to overwrite it?";
					confirmDuplicateSlotDialog.Visible = true;
					return;
				}

				awocObj.awocSlotsRes.AddSlot(addSlotNameEdit.Text);
				addSlotNameEdit.Text = "";
				awocObj.SaveAWOC();
				PopulateSlotsContainer();
			}
		}

		/// <summary>
		/// All of the children in slotsScrollContainer are freed before looping through each AWOCSlotRes in 
		/// awocObj.awocSlotsRes.slotContainers. For each AWOCSlotContainerRes, a dictionary containing the names 
		/// of all the slots in awocObj.awocSlotsRes.slotContainers is created and used
		/// to initilize a new SlotContainer. Listeners for all of the signals the new SlotConainer will emit are assigned
		/// before adding the new SlotContainer as a child of slotsScrollContainer.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void PopulateSlotsContainer()
		{
			if(awocObj != null)
			{
				foreach(SlotContainer child in slotsScrollContainer.GetChildren())
					child.QueueFree();

				if(awocObj.awocSlotsRes.slotContainers != null)
				{
					foreach(SlotContainerRes slotContainerRes in awocObj.awocSlotsRes.slotContainers)
					{
						Dictionary<string,string> slotNameDictionary = new Dictionary<string, string>();
						foreach(SlotContainerRes innerSlot in awocObj.awocSlotsRes.slotContainers)
						{
							slotNameDictionary.Add(innerSlot.slotName,innerSlot.slotName);
						}
						SlotContainer container = slotContainer.Instantiate<SlotContainer>();
						container.InitSlotContainer(slotContainerRes, slotNameDictionary);
						container.RenameSlot += OnRenameSlot;
						container.DeleteSlot += OnDeleteSlot;
						container.DeleteHideSlot += OnDeleteHideSlot;
						container.AddHideSlot += OnAddHideSlot;
						slotsScrollContainer.AddChild(container);
					}
				}
			}
		}

		/// <summary>
		/// In response to the confirmDuplicateSlotDialog being confirmed, calls
		/// awocObj.awocSlotsRes.ResetSlot(addSlotNameEdit.Text) and awocObj is saved to disk.
		/// </summary>
		/// <param name="none">none</param>
		/// <returns>void</returns>
		void _on_confirm_duplicate_slot_dialog_confirmed()
		{
			awocObj.awocSlotsRes.ResetSlot(addSlotNameEdit.Text);
			awocObj.SaveAWOC();
		}

		/// <summary>
		/// Overridden from CenterPaneBase, awocEditor and awocObj are set. If awocObj.awocSlotsRes is null, a 
		/// new AWOCSlotRes is created and assigned to awocObj.awocSlotsRes. Finally, SlotsContainer is populated. 
		/// </summary>
		/// <param name="awocEditor">The main controller for the AWOC editor window</param>
		/// <returns>void</returns>
		public override void InitPane(AWOCEditor awocEditor)
		{
			this.awocEditor = awocEditor;
			awocObj = awocEditor.awocObj;
			if(awocObj.awocSlotsRes == null)
			{
				awocObj.awocSlotsRes = new SlotsRes();
			}
			PopulateSlotsContainer();
		}
	}
}