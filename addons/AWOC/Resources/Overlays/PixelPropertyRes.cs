using Godot;
using System;

namespace AWOC
{
    [Tool]
    public partial class PixelPropertyRes : Resource
    {
        [Export] int arrayPos;
        [Export] float strength;

        public PixelPropertyRes()
        {
            arrayPos = 0;
            strength = 0;
        }

        public PixelPropertyRes(int arrayPos, float strength)
        {
            this.arrayPos = arrayPos;
            this.strength = strength;
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
			string stringToHash = arrayPos + strength + "PixelPropertyRes";
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


