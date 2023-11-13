using Godot;

namespace AWOC
{
    [Tool]
    public partial class OverlayRes : Resource
    {
        [Export] string overlayName;
        [Export] OverlayImageArray[] overlayImageArray;
        [Export] MatType overlayType;
        [Export] float overlayStrength;

        void InitPixelArray(Texture2D texture)
        {
            Image textureImage = texture.GetImage();
            int textureWidth = texture.GetWidth();
            int textureHeight = texture.GetHeight();
            overlayImageArray = new OverlayImageArray[textureWidth];
            for(int a = 0; a < textureWidth; a++)
            {
                overlayImageArray[a] = new OverlayImageArray
                {
                    imageArray = new float[textureHeight]
                };

                for (int b = 0; b < textureHeight; b++)
                {
                    overlayImageArray[a].imageArray[b] = textureImage.GetPixel(a,b).R;
                }
            }  
        }
                    
        void ApplyColorToTexture(Texture2D sourceTexture, Color color)
        {
            int arrayWidth = overlayImageArray.Length;
            int arrayHeight = overlayImageArray[0].imageArray.Length;
            Image sourceImage = sourceTexture.GetImage();
            for(int a = 0; a < arrayWidth; a++)
            {
                for(int b = 0; b < arrayHeight; b++)
                {
                    if(overlayImageArray[a].imageArray[b] > 0)
                    {
                        Color sourceColor = sourceImage.GetPixel(a,b);
                        sourceImage.SetPixel(a, b, sourceColor * color);
                    }
                }
            }        
        }   
    }
}