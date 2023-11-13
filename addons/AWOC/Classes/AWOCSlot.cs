using Godot;

namespace AWOC
{
	public partial class AWOCSlot : Resource
	{
		[Export] public string slotName;
		[Export] public string[] hideSlots;

		public AWOCSlot(){}

		public AWOCSlot(string slotName)
		{
			this.slotName = slotName;
		}
	}
}