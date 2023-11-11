using Godot;
using Godot.NativeInterop;
using System;

namespace AWOC
{
	[Tool]
	public partial class BaseCenterPane: Control
	{
        [Export] public AWOCEditor awocEditor;

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
	}
}