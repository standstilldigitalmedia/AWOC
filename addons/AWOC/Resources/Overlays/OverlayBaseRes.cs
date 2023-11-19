using Godot;
using Godot.NativeInterop;

namespace AWOC
{
    public enum OverlayTypes
    {
        Metallic,
        Roughness,
        Color,
        Texture,
        Emission
    }

    [Tool]
    public partial class OverlayBaseRes : Resource
    {
        [Export] public string overlayName;
        [Export] public OverlayRowRes[] overlayRows;
        [Export] public OverlayTypes overlayType;
        [Export] int imageWidth;
        [Export] int imageHeight;

        public OverlayBaseRes()
        {

        }

        public OverlayBaseRes(string sourceImagePath)
        {
            ReadTexture2D(sourceImagePath);
        }

        public void ReadTexture2D(string sourceImagePath, float sourceStrength = 0)
        {
            Image sourceImage = GD.Load<Image>(sourceImagePath);
            imageWidth = sourceImage.GetWidth();
            imageHeight = sourceImage.GetHeight();

            byte[] data = sourceImage.GetData();
            int dataSize = data.Length;
            float propStrength = sourceStrength;
            overlayRows = new OverlayRowRes[imageWidth];
            for(int a = 0; a < imageWidth; a++)
            {
                overlayRows[a] = new OverlayRowRes(imageHeight);
            }
            int wCounter = 0;
            int hCounter = 0;
            for(int b = 0; b < dataSize; b += 4)
            {
                if(data[b] > 0)
                {
                    if(sourceStrength == 0)
                        propStrength = data[b];

                    overlayRows[wCounter].strengths[hCounter] = propStrength;
                }  
                hCounter++;
                if(hCounter > imageHeight)
                {
                    hCounter = 0;
                    wCounter ++;
                }
            }
        }
    }
}