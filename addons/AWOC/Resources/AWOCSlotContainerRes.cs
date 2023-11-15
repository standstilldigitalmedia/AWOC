using Godot;
using System;

namespace AWOC
{
    public partial class AWOCSlotContainerRes : Resource
    {
        [Export] public string slotName;
        [Export] public string[] hideSlots;

        public AWOCSlotContainerRes()
		{
			slotName = "empty";
		}

		public AWOCSlotContainerRes(string slotName)
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
			string stringToHash = slotName + "SlotRes";
            string stringToHashUpper = stringToHash.ToUpper();
            foreach (char c in stringToHashUpper)
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
