using Godot;
using System;

namespace AWOC
{
	
	[Tool]
	public partial class AWOCRes : Resource
	{
		[Export] string awocName;
		[Export] public string awocPath;
		[Export] public AWOCSlotRes[] slots;
		[Export] public AWOCAvatarRes awocAvatarRes;

		public AWOCRes()
		{
			awocName = "empty";
		}

		public AWOCRes(string awocName, string awocPath)
		{
			this.awocName = awocName;
			this.awocPath = awocPath;
		}

		public void SaveAWOC()
		{
			ResourceSaver.Save(this, awocPath);
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
			string stringToHash = awocName + "AWOCRes";
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