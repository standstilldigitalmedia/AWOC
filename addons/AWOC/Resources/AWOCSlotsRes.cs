using Godot;

namespace AWOC
{
    public partial class AWOCSlotsRes : Resource
    {
        [Export] public AWOCSlotContainerRes[] slotContainers;

		public void AddSlot(string slotName)
		{
			slotContainers = AWOCHelper.AddElementToArray(new AWOCSlotContainerRes(slotName), slotContainers);
		}

		public void RenameSlot(string slotToRename, string newName)
		{
			foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotToRename)
				{
					slotContainer.slotName = newName;
					return;
				}
			}
		}

		public void DeleteSlot(string slotToDelete)
		{
			foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotToDelete)
				{
					slotContainers = AWOCHelper.RemoveElementFromArray(slotContainer, slotContainers);
					return;
				}
			}
		}

		public void AddHideSlot(string slotName, string hideSlotName)
		{
			foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotName)
				{
					slotContainer.hideSlots = AWOCHelper.AddElementToArray(hideSlotName, slotContainer.hideSlots);
					return;
				}
			}
		}

		public void DeleteHideSlot(string slotName, string hideSlotName)
		{
			foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotName)
				{
					slotContainer.hideSlots = AWOCHelper.RemoveElementFromArray(hideSlotName, slotContainer.hideSlots);
					return;
				}
			}
		}

        public bool SlotExists(string slotName)
        {
			if(slotContainers == null)
			 	return false;
				
            foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotName)
				{
					return true;
				}
			}
            return false;
        }

        public void ResetSlot(string slotName)
        {
            foreach(AWOCSlotContainerRes slotContainer in slotContainers)
			{
				if(slotContainer.slotName == slotName)
				{
					slotContainer.hideSlots = null;
                    return;
				}
			}
        }
    }
}


