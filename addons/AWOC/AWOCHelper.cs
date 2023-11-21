using Godot;

namespace AWOC
{
	public static partial class AWOCHelper
	{
		/// <summary>
		/// Splits an entire path until only the file name remains
		/// </summary>
		/// <param name="path">The path to be split</param>
		/// <returns>void</returns>
		public static string GetFileNameFromPath(string path)
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
		public static void InitFileDialog(FileDialog dialog)
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
		public static T[] RemoveElementFromArray<T>(T elementToRemove, T[] sourceArray)
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
		public static T[] AddElementToArray<T>(T elementToAdd, T[] sourceArray)
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

		public static void ColorTextureWithOverlay(Image textureImage, Image overlayImage, Color color, float colorStrength)
		{
			byte[] textureImageBytes = textureImage.GetData();
			byte[] overlayImageBytes = overlayImage.GetData();

			int textureImageWidth = textureImage.GetWidth();
			int textureImageHeight = textureImage.GetHeight();
			int overlayImageWidth = overlayImage.GetWidth();
			int overlayImageHeight = overlayImage.GetHeight();

			int textureImageBytesSize = textureImageBytes.Length;
			int overlayImageBytesSize = overlayImageBytes.Length;

			if(textureImageWidth != overlayImageWidth || textureImageHeight != overlayImageHeight || textureImageBytesSize != overlayImageBytesSize)
			{
				GD.Print("Texture and overlay sizes must be the same and must be the same format");
				return;
			}

			for(int a = 0; a < textureImageBytesSize; a += 4)
			{
				if(overlayImageBytes[a] > 0)
				{
					Color imgColor = new Color(textureImageBytes[a],textureImageBytes[a + 1],textureImageBytes[a + 2],255);
					Color newColor = imgColor.Lerp(color, colorStrength);
					textureImageBytes[a] = (byte)newColor.R;
					textureImageBytes[a + 1] = (byte)newColor.G;
					textureImageBytes[a + 2] = (byte)newColor.B;
					textureImageBytes[a + 3] = (byte)newColor.A;
				}
			}
			textureImage.SetData(textureImageWidth, textureImageHeight,false,textureImage.GetFormat(),textureImageBytes);
		}

		public static void CombineImages(Image destImage, Image sourceImage, int offset, int offsetMax)
		{
			byte[] destImageBytes = destImage.GetData();
			byte[] sourceImageBytes = sourceImage.GetData();

			int destImageWidth = destImage.GetWidth();
			int destImageHeight = destImage.GetHeight();
			int sourceImageWidth = sourceImage.GetWidth();
			int sourceImageHeight = sourceImage.GetHeight();

			if(destImageHeight != sourceImageHeight)
			{
				GD.Print("Heights of all images must match");
				return;
			}

			if(destImageWidth != sourceImageWidth * offsetMax)
			{
				GD.Print("Destination image width must be the width of the source image multiplied by offsetMax");
				return;
			}

			int destPosition = sourceImageWidth * 4 * offset;
			int widthCounter = 0;
			for(int a = 0; a < sourceImageBytes.Length; a += 4)
			{
				destImageBytes[destPosition] = sourceImageBytes[a];
				destImageBytes[destPosition + 1] = sourceImageBytes[a+1];
				destImageBytes[destPosition + 2] = sourceImageBytes[a+2];
				destImageBytes[destPosition + 3] = sourceImageBytes[a+3];

				widthCounter +=4;
				if(widthCounter >= (sourceImageWidth * 4))
				{
					widthCounter = 0;
					destPosition += (sourceImageWidth * 4 * (offsetMax-1)) + 4;
				}
				else
					destPosition += 4;
			}
			destImage.SetData(destImageWidth, destImageHeight,false,destImage.GetFormat(),destImageBytes);
		}
	}
}