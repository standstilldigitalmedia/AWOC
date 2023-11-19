using Godot;
using System;

namespace AWOC
{
    [Tool]
    public partial class SlotContainerRes : Resource
    {
        [Export] public string slotName;
        [Export] public string[] hideSlots;

        public SlotContainerRes()
		{
			slotName = "empty";
		}

		public SlotContainerRes(string slotName)
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
			string stringToHash = slotName + "SlotContainerRes";
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

			if(int.TryParse(replaced, out int j))
				return j;
			else
			{
				GD.Print("TryParse failed in AWOCSlotContainerRes.GetHashCode()");
				return 1;
			}	
		}
    }
}
