using Godot;
using System;

namespace AWOC
{
	[Tool]
	public partial class AWOCSlotRes : Resource
	{
		[Export] public string slotName;
		[Export] public string[] hideSlots;

		public AWOCSlotRes(){}

		public AWOCSlotRes(string slotName)
		{
			this.slotName = slotName;
		}

		public override bool Equals(Object obj)
		{			
			if(GetHashCode() == obj.GetHashCode())
				return true;
			return false;
		}

		public override int GetHashCode()
		{
            string replaced = string.Empty;
            string slotNameUpper = slotName.ToUpper();
            foreach (char c in slotNameUpper)
            {
                if (char.IsDigit(c))
                    replaced += c;
                else if (char.IsLetter(c))  
                {
                    int asc = (int)c - (int)'A' + 1;
                    replaced += asc;
                }
            } 
			Int32.TryParse(replaced, out int j);
			return j;
		}
	}
}