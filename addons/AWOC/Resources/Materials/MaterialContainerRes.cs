using Godot;
using System;

namespace AWOC
{
	[Tool]
	public partial class MaterialContainerRes : Resource
	{
		[Export] public string materialName;
		[Export] public Texture2D albedoTexture;
		[Export] OverlayBaseRes[] overlays;

		public MaterialContainerRes()
		{
			materialName = "empty";
		}

		public MaterialContainerRes(string materialName)
		{
			this.materialName = materialName;
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
			string stringToHash = materialName + "MaterialContainerRes";
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
				GD.Print("TryParse failed in AWOCMaterialContainerRes.GetHashCode()");
				return 1;
			}	
		}
	}
}


