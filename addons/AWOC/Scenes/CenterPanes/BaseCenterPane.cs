using Godot;
using System.Collections.Generic;
using System.Linq;

namespace AWOC
{
	[Tool]
	public abstract partial class BaseCenterPane: Control
	{
        [Export] public AWOCEditor awocEditor;
		[Export] public AWOCRes awocObj;

		public abstract void InitPane(AWOCEditor awocEditor);

		public string GetFileNameFromPath(string path)
		{
			//split the path at forward slashes
			string[] dirSplit = path.Split("/");
			int dirSplitSize = dirSplit.Length;
			//the last element in the dir_split array is the file name
			//split the file name at the period so file_split[0] is the
			//file name without the extension
			string[] fileSplit = dirSplit[dirSplitSize -1].Split(".");
			return fileSplit[0];
    	}

		public void InitFileDialog(FileDialog dialog)
		{
			dialog.Visible = false;
			dialog.ClearFilters();
			dialog.AddFilter("*.res", "Resource");
			dialog.CurrentDir = "/";
		}

		public string[] RemoveStringFromArray(string removeString, string[] sourceArray)
		{
			if(sourceArray != null && removeString != null)
			{
				List<string> newList = new List<string>();
				bool deleted = false;
				foreach(string nameString in sourceArray)
				{
					if(nameString != removeString)
						newList.Append(nameString);
					else
						deleted = true;
				}
				if(deleted)
				{
					string[] newArray = new string[sourceArray.Length -1];
					for(int a = 0; a < newArray.Length; a++)
					{
						newArray[a] = newList[a];
					}
					return newArray;
				}
			}
			return null;
		}

		public string[] AddStringToArray(string addString, string[] sourceArray)
		{
			if(sourceArray == null || sourceArray.Length < 1)
			{
				string[] returnArray = new string[1];
				returnArray[0] = addString;
				return returnArray;
			}
			string[] newArray = new string[sourceArray.Length + 1];
			for(int a = 0; a < sourceArray.Length; a++)
			{
				newArray[a] = sourceArray[a];
			}
			newArray[newArray.Length -1] = addString;
			return newArray;
		}
	}
}