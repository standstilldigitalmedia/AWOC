using Godot;
using System;

namespace AWOC
{
	[Tool]
    public partial class SlotsRes : Resource
    {
        [Export] public SlotContainerRes[] slotContainers;

		/// <summary>
		/// </summary>
		/// <param name="slotName">The name of the newslot</param>y
		/// <returns>void</returns>
		
		SlotContainerRes GetSlotByName(string slotName)
		{
			foreach(SlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotName)
				{
					return slotContainer;
				}
			}
			return null;
		}

		public void AddSlot(string slotName)
		{
			slotContainers = AWOCHelper.AddElementToArray(new SlotContainerRes(slotName), slotContainers);
		}

		public void RenameSlot(string slotToRename, string newName)
		{
			GetSlotByName(slotToRename).slotName = newName;
		}

		public void DeleteSlot(string slotToDelete)
		{
			slotContainers = AWOCHelper.RemoveElementFromArray(GetSlotByName(slotToDelete), slotContainers);
		}

		public void AddHideSlot(string slotName, string hideSlotName)
		{
			GetSlotByName(slotName).hideSlots = AWOCHelper.AddElementToArray(hideSlotName, GetSlotByName(slotName).hideSlots);
		}

		public void DeleteHideSlot(string slotName, string hideSlotName)
		{
			GetSlotByName(slotName).hideSlots = AWOCHelper.RemoveElementFromArray(hideSlotName, GetSlotByName(slotName).hideSlots);
		}

        public bool SlotExists(string slotName)
        {
			if(slotContainers == null)
			 	return false;
				
            if(GetSlotByName(slotName) != null)
				return true;
            return false;
        }

        public void ResetSlot(string slotName)
        {
			GetSlotByName(slotName).hideSlots = null;
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
			string stringToHash = "";
			if(slotContainers == null)
			{
				stringToHash = "empty";
			}
			else
			{
				foreach(SlotContainerRes slotContainer in slotContainers)
				{
					stringToHash += slotContainer.slotName;
					if(slotContainer.hideSlots!= null)
						foreach(string hideSlot in slotContainer.hideSlots)
							stringToHash += hideSlot;
				}
			}
			
			stringToHash += "SlotRes";	
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
				GD.Print("TryParse failed in AWOCSlotRes.GetHashCode()");
				return 1;
			}	
		}
    }
}


