using Godot;

namespace AWOC
{
	[Tool]
	public abstract partial class PaneBase : Node
	{
		/// <summary>
		/// Splits an entire path until only the file name remains
		/// </summary>
		/// <param name="path">The path to be split</param>
		/// <returns>void</returns>
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

		/// <summary>
		/// Sets the visiblity of dialog to fals, clears the dialogs filters, adds a filter for Resource files and sets
		/// dialog's current directory to "/"
		/// </summary>
		/// <param name="dialog">The dialog to be initilized</param>
		/// <returns>void</returns>
		public void InitFileDialog(FileDialog dialog)
		{
			dialog.Visible = false;
			dialog.ClearFilters();
			dialog.AddFilter("*.res", "Resource");
			dialog.CurrentDir = "/";
		}

		/// <summary>
		/// Creates an array that is one element smaller than sourceArray.Length and copies the contents of sourceArray into
		/// the new array, leaving out elementToRemove.
		/// </summary>
		/// <param name="elementToRemove">The element to remove from the array</param>
		/// <param name="sourceArray">The original array to be modified</param>
		/// <returns>A new array that is a copy of sourceArray minus elementToRemove</returns>		
		public T[] RemoveElementFromArray<T>(T elementToRemove, T[] sourceArray)
		{
			if(sourceArray != null && elementToRemove != null)
			{
				//get the length of the source array and subtract one
				int destArrayLength = sourceArray.Length -1;
				//if this would create a new array with zero elements, return null
				if(destArrayLength <= 0)
					return null;
				T[] destArray = new T[destArrayLength];
				int destCounter = 0;
				for(int sourceCounter = 0; sourceCounter < sourceArray.Length; sourceCounter++)
				{
					if(!sourceArray[sourceCounter].Equals(elementToRemove))
					{
						destArray[destCounter] = sourceArray[sourceCounter];
						destCounter ++;
					}
				}
				return destArray;
			}
			return null;
		}

		/// <summary>
		/// Creates an array that is one element larger than sourceArray.Length and copies the contents of sourceArray into
		/// the new array, adding elementToAdd to the last element in the array.
		/// </summary>
		/// <param name="elementToAdd">The element to add to the array</param>
		/// <param name="sourceArray">The original array to be modified</param>
		/// <returns>A new array that is a copy of sourceArray plus elementToRemove</returns>	
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

