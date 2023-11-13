using Godot;
using System.Collections.Generic;

namespace AWOC
{
	[Tool]
	public partial class SlotsPane : BaseCenterPane
	{
		[Export] PackedScene slotContainer;
		[Export] LineEdit addSlotNameEdit;
		[Export] VBoxContainer slotsScrollContainer;
		[Export] ConfirmationDialog confirmDuplicateSlotDialog;

		void _on_add_slot_button_pressed()
		{ 
			if(addSlotNameEdit.Text.Length > 3)
			{
				if(awocObj != null && awocObj.slots != null && awocObj.slots.Length > 0)
				{
					foreach(AWOCSlot slot in awocObj.slots)
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
				
				AWOCSlot newSlot = new AWOCSlot(addSlotNameEdit.Text);
				addSlotNameEdit.Text = "";
				awocObj.slots = AddElementToArray(newSlot, awocObj.slots);
				awocObj.SaveAWOC();
				//ResourceSaver.Save(newSlot, awocEditor.awocPath);
				PopulateSlotsContainer();
			}
		}

		void OnRenameSlot(AWOCSlot oldSlot, string newSlotName)
		{
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == oldSlot.slotName)
				{
					slot.slotName = newSlotName;
					awocObj.SaveAWOC();
					return;
				}
			}
		}

		void OnDeleteSlot(AWOCSlot slotToDelete)
		{
			awocObj.slots = RemoveElementFromArray(slotToDelete, awocObj.slots);
			awocObj.SaveAWOC();
		}

		void OnDeleteHideSlot(string slotName, string hideSlotName)
		{
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == slotName)
				{
					slot.hideSlots = RemoveElementFromArray(slotName, slot.hideSlots);
					awocObj.SaveAWOC();
					return;
				}
			}
		}

		void OnAddHideSlot(AWOCSlot slotToAddTo, string hideSlotName)
		{
			slotToAddTo.hideSlots = AddElementToArray(hideSlotName, slotToAddTo.hideSlots);
			awocObj.SaveAWOC();
		}

		void PopulateSlotsContainer()
		{
			if(awocObj.slots != null && awocObj.slots.Length > 0)
			{
				foreach(SlotContainer child in slotsScrollContainer.GetChildren())
					child.QueueFree();

				foreach(AWOCSlot slot in awocObj.slots)
				{
					SlotContainer container = slotContainer.Instantiate<SlotContainer>();
					Dictionary<string,string> slotNameDictionary = new Dictionary<string, string>();
					foreach(AWOCSlot innerSlot in awocObj.slots)
					{
						slotNameDictionary.Add(innerSlot.slotName,innerSlot.slotName);
					}
					container.InitSlotContainer(slot, slotNameDictionary, slot.hideSlots);
					container.RenameSlot += OnRenameSlot;
					container.DeleteSlot += OnDeleteSlot;
					container.DeleteHideSlot += OnDeleteHideSlot;
					container.AddHideSlot += OnAddHideSlot;
					slotsScrollContainer.AddChild(container);
				}
			}
		}
		public override void InitPane(AWOCEditor awocEditor)
		{
			this.awocEditor = awocEditor;
			awocObj = awocEditor.awocObj;
			PopulateSlotsContainer();
		}

		void _on_confirmation_dialog_confirmed()
		{
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == addSlotNameEdit.Text)
				{
					slot.hideSlots = null;
					awocObj.SaveAWOC();
					return;
				}
			}
		}
	}
}