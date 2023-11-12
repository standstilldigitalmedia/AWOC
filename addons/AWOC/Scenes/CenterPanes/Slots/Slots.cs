using Godot;
using Godot.Collections;

namespace AWOC
{
	[Tool]
	public partial class Slots : BaseCenterPane
	{
		[Export] PackedScene slotContainer;
		[Export] LineEdit addSlotNameEdit;
		[Export] VBoxContainer slotsScrollContainer; 

		void PopulateSlotsContainer()
		{
			if(awocEditor != null && awocEditor.awocObj != null)
			{
				if(awocEditor.awocObj.slotsDictionary == null)
				{
					awocEditor.awocObj.slotsDictionary = new Dictionary<string,Dictionary<string,string>>();
					return;
				}

				foreach(SlotContainer child in slotsScrollContainer.GetChildren())
				{
					child.QueueFree();
				}
					
				var keys = awocEditor.awocObj.slotsDictionary.Keys;
				foreach(string slot in keys)
				{
					SlotContainer container = slotContainer.Instantiate<SlotContainer>();
					container.awocEditor = awocEditor;
					container.SetSlotName(slot);
					slotsScrollContainer.AddChild(container);
				}
			}
		}

		void SetSlotName1(string slotName, Node slotObj)
		{
			//slotObj.SetSlotName(slotName);
		}

		void _on_add_slot_button_pressed()
		{
			string newSlotName = addSlotNameEdit.Text;
			if(newSlotName != null && newSlotName.Length > 3 && awocEditor.awocObj != null)
			{
				awocEditor.awocObj.slotsDictionary[newSlotName] = new Dictionary<string, string>();
				awocEditor.SaveCurrentAWOC();
				PopulateSlotsContainer();
			}
		}

		public override void _Ready()
		{
			PopulateSlotsContainer();
		}
	}
}