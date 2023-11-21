using Godot;

public partial class TestingImages : Control
{
	[Export] TextureRect textRect;

	void ColorTextureWithOverlay(Image textureImage, Image overlayImage, Color color, float colorStrength)
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

	void CombineImages(Image destImage, Image sourceImage, int offset, int offsetMax)
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

	public override void _Ready()
	{
		Texture2D feetAlbedo = GD.Load<Texture2D>("res://TestModel/Textures/Feet/albedo.png");
		Texture2D handsAlbedo = GD.Load<Texture2D>("res://TestModel/Textures/Hands/albedo.png");
		Texture2D legsAlbedo = GD.Load<Texture2D>("res://TestModel/Textures/Legs/albedo.png");
		Texture2D torsoAlbedo = GD.Load<Texture2D>("res://TestModel/Textures/Torso/albedo.png");

		Texture2D topOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/top.png");
		Texture2D leftOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/left.png");
		Texture2D middleOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/middle.png");
		Texture2D rightOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/right.png");
		Texture2D bottomOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/bottom.png");
		Texture2D underBottomOverlay = GD.Load<Texture2D>("res://TestModel/Textures/Overlays/underBottom.png");

		int newWidth = feetAlbedo.GetWidth() * 3;
		int newHeight = feetAlbedo.GetHeight();
		int offsetMax = 3;

		Image feetImage = feetAlbedo.GetImage();
		Image handsImage = handsAlbedo.GetImage();
		Image topOverlayImage = topOverlay.GetImage();
		Image bottomOverlayImage = bottomOverlay.GetImage();
		Image leftOverlayImage = leftOverlay.GetImage();

		Image destImage = Image.Create(newWidth,newHeight,false, Image.Format.Rgba8);

		ColorTextureWithOverlay(feetImage,topOverlayImage,new Color(255,0,0,255),0.5f);
		ColorTextureWithOverlay(feetImage,bottomOverlayImage,new Color(0,255,0,255),0.5f);

		ColorTextureWithOverlay(handsImage,leftOverlayImage,new Color(0,0,255,255),0.5f);

		CombineImages(destImage,feetImage,0,offsetMax);
		CombineImages(destImage, handsImage,1, offsetMax);

		ImageTexture newTexture = ImageTexture.CreateFromImage(destImage);
		textRect.Texture = newTexture;
	}
}
