using Godot;
using System;

namespace AWOC
{
    [Tool]
    public partial class MaterialsRes : Resource
    {
        [Export] public MaterialContainerRes[] materialContainers;

        MaterialContainerRes GetMaterialByName(string materialName)
		{
			foreach(MaterialContainerRes materialContainer in materialContainers)
			{
				if(materialContainer.materialName == materialName)
				{
					return materialContainer;
				}
			}
			return null;
		}

		public void AddMaterial(string materialName)
		{
			materialContainers = AWOCHelper.AddElementToArray(new MaterialContainerRes(materialName), materialContainers);
		}

		public void RenameMaterial(string materialToRename, string newName)
		{
			GetMaterialByName(materialToRename).materialName = newName;
		}

		public void DeleteMaterial(string materialToDelete)
		{
			materialContainers = AWOCHelper.RemoveElementFromArray(GetMaterialByName(materialToDelete), materialContainers);
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
			if(materialContainers == null)
			{
                stringToHash = "empty";
            }
            else
            {
				foreach(MaterialContainerRes materialContainer in materialContainers)
				{
					stringToHash += materialContainer.materialName;
				}
			}
			
			stringToHash += "MaterialRes";	
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
				GD.Print("TryParse failed in AWOCMaterialsRes.GetHashCode()");
				return 1;
			}	
		}
    }
}