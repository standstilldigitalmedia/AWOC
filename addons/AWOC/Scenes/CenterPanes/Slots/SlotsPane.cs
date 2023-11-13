using Godot;
using System.Collections.Generic;
using System.Linq;
//using Godot.Collections;

namespace AWOC
{
	[Tool]
	public partial class SlotsPane : BaseCenterPane
	{
		[Export] PackedScene slotContainer;
		[Export] LineEdit addSlotNameEdit;
		[Export] VBoxContainer slotsScrollContainer;

		void _on_add_slot_button_pressed()
		{
			string newSlotName = addSlotNameEdit.Text;
			addSlotNameEdit.Text = "";
            AWOCSlot newSlot = new AWOCSlot(newSlotName);
            if (awocObj.slots == null || awocObj.slots.Length < 1)
			{
				AWOCSlot[] returnArray = new AWOCSlot[1];
				returnArray[0] = newSlot;
				awocObj.slots = returnArray;
				awocEditor.SaveCurrentAWOC();
				PopulateSlotsContainer();
				return;
			}
			AWOCSlot[] newArray = new AWOCSlot[awocObj.slots.Length + 1];
			for(int a = 0; a < awocObj.slots.Length; a++)
				newArray[a] = awocObj.slots[a];
			newArray[newArray.Length -1] = newSlot;
			awocObj.slots = newArray;
			awocEditor.SaveCurrentAWOC();
			PopulateSlotsContainer();
		}

		void OnRenameSlot(string oldSlotName, string newSlotName)
		{
			GD.Print(oldSlotName + " " + newSlotName);
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == oldSlotName)
				{
					slot.slotName = newSlotName;
					awocEditor.SaveCurrentAWOC();
					return;
				}
			}
		}

		void OnDeleteSlot(string slotName)
		{
			GD.Print("slot to delete " + slotName);
			int slotsLength = awocObj.slots.Length;
			GD.Print("slotsLength " + slotsLength);
			if(slotsLength <= 1)
			{
				GD.Print("set slots to null");
				awocObj.slots = null;
				awocEditor.SaveCurrentAWOC();
				return;
			}
			List<AWOCSlot> newList = new List<AWOCSlot>();
			bool deleted = false;
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName != slotName)
				{
					GD.Print("first loop " + slot.slotName);
					newList.Append(slot);
				}
				else
				{
					deleted = true;
					GD.Print("deleted");
				}
					
			}
			if(deleted)
			{
				int newSlotsLength = slotsLength - 1;
				GD.Print("new slots length " + newSlotsLength);
				AWOCSlot[] newArray = new AWOCSlot[newSlotsLength];
				for(int a = 0; a < newArray.Length -1; a++)
				{
					GD.Print(a + " " + newArray[a] + " " + newList[a]);
					newArray[a] = newList[a];
				}
				GD.Print(Json.Stringify(newArray));
				awocObj.slots = newArray;
				awocEditor.SaveCurrentAWOC();
			}
		}

		void OnDeleteHideSlot(string slotName, string hideSlotName)
		{
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == slotName)
				{
					slot.hideSlots = RemoveStringFromArray(slotName, slot.hideSlots);
					awocEditor.SaveCurrentAWOC();
					return;
				}
			}
		}

		void OnAddHideSlot(string slotName, string hideSlotName)
		{
			foreach(AWOCSlot slot in awocObj.slots)
			{
				if(slot.slotName == slotName)
				{
					slot.hideSlots = AddStringToArray(slotName, slot.hideSlots);
					awocEditor.SaveCurrentAWOC();
					return;
				}
			}
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
						GD.Print(innerSlot.slotName);
						slotNameDictionary.Add(innerSlot.slotName,innerSlot.slotName);
					}
					container.InitSlotContainer(slot.slotName, slotNameDictionary, slot.hideSlots);
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
	}
}