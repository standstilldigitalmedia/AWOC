using Godot;
using System.Collections.Generic;

namespace AWOC
{
	public abstract partial class PaneBase : Node
	{
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
		
		public T[] RemoveElementFromArray<T>(T elementToRemove, T[] sourceArray)
		{
			if(sourceArray != null && elementToRemove != null)
			{
				int sourceArrayLength = sourceArray.Length -1;
				if(sourceArrayLength <= 0)
					return null;
				List<T> newList = new List<T>();
				bool deleted = false;
				foreach(T element in sourceArray)
				{
					if(!element.Equals(elementToRemove))
						newList.Add(element);
					else
						deleted = true;
				}
				if(deleted)
				{
					T[] newArray = new T[sourceArrayLength];
					for(int a = 0; a < sourceArrayLength; a++)
					{
						newArray[a] = newList[a];
					}
					return newArray;
				}
			}
			return null;
		}

		public T[] AddElementToArray<T>(T elementToAdd, T[] sourceArray)
		{	
			if(elementToAdd == null)
			{
				return null;
			}

			if(sourceArray == null || sourceArray.Length < 1)
			{
				T[] returnArray = new T[1];
				returnArray[0] = elementToAdd;
				return returnArray;
			}
			T[] newArray = new T[sourceArray.Length + 1];
			for(int a = 0; a < sourceArray.Length; a++)
			{
				newArray[a] = sourceArray[a];
			}
			newArray[newArray.Length -1] = elementToAdd;
			return newArray;
		}
	}
}

