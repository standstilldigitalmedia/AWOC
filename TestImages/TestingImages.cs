using Godot;

public partial class TestingImages : Control
{
	[Export] TextureRect textRect;

	void AddImageWithOverlay(Image mainImage, Texture2D albedoTexture, Texture2D overlayTexture, int offset, int offsetMax, Color color, float colorStrength)
	{
		Image albedoImage = albedoTexture.GetImage();
		Image overlayImage = overlayTexture.GetImage();

		byte[] mainImageBytes = mainImage.GetData();
		byte[] albedoImageBytes = albedoImage.GetData();
		byte[] overlayImageBytes = overlayImage.GetData();

		int mainImageWidth = mainImage.GetWidth();
		int mainImageHeight = mainImage.GetHeight();
		int albedoImageWidth = albedoImage.GetWidth();
		int albedoImageHeight = albedoImage.GetHeight();
		int overlayImageWidth = overlayImage.GetWidth();
		int overlayImageHeight = overlayImage.GetHeight();

		if(mainImageHeight != albedoImageHeight || albedoImageHeight != overlayImageHeight)
		{
			GD.Print("Heights of all images must match");
			return;
		}

		if(albedoImageWidth != overlayImageWidth)
		{
			GD.Print("Albedo and overlay widths must be the same");
			return;
		}

		int destPosition = albedoImageWidth * 4 * offset;
		int widthCounter = 0;
		for(int a = 0; a < albedoImageBytes.Length; a += 4)
		{
			if(overlayImageBytes[a] > 0)
			{
				Color imgColor = new Color(albedoImageBytes[a],albedoImageBytes[a + 1],albedoImageBytes[a + 2],255);
				Color newColor = imgColor.Lerp(color, colorStrength);
				mainImageBytes[destPosition] = (byte)newColor.R;
				mainImageBytes[destPosition + 1] = (byte)newColor.G;
				mainImageBytes[destPosition + 2] = (byte)newColor.B;
				mainImageBytes[destPosition + 3] = (byte)newColor.A;
			}
			else
			{
				mainImageBytes[destPosition] = albedoImageBytes[a];
				mainImageBytes[destPosition + 1] = albedoImageBytes[a+1];
				mainImageBytes[destPosition + 2] = albedoImageBytes[a+2];
				mainImageBytes[destPosition + 3] = albedoImageBytes[a+3];
			}
			widthCounter +=4;
			if(widthCounter >= (albedoImageWidth * 4))
			{
				widthCounter = 0;
				destPosition += (albedoImageWidth * 4 * (offsetMax-1)) + 4;
			}
			else
				destPosition += 4;
		}
		mainImage.SetData(mainImageWidth, mainImageHeight,true,Image.Format.Rgba8,mainImageBytes);
	}

	void AddImage(byte[] mainImageBytes, string imageToAddPath, int offset, Color color)
	{
		Texture2D text = GD.Load<Texture2D>(imageToAddPath);
		Image img = text.GetImage();
		byte[] imgData = img.GetData();
		int width = img.GetWidth();

		int destPosition = width * 4 * offset;
		int widthCounter = 0;
		for(int a = 0; a < imgData.Length; a += 4)
		{
			if(imgData[a] > 0)
			{
				Color imgColor = new Color(imgData[a],imgData[a + 1],imgData[a + 2],255);
				Color newColor = color.Lerp(imgColor, 0.5f);
				mainImageBytes[destPosition] = (byte)(newColor.R);
				mainImageBytes[destPosition + 1] = (byte)(newColor.G);
				mainImageBytes[destPosition + 2] = (byte)(newColor.B);
				mainImageBytes[destPosition + 3] = (byte)(newColor.A);
			}
			widthCounter +=4;
			if(widthCounter >= (width * 4))
			{
				widthCounter = 0;
				destPosition += (width * 4) + (width * 4)+ (width * 4) + 4;
			}
			else
				destPosition += 4;
		}
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

		Image destImage = Image.Create(newWidth,newHeight,true, Image.Format.Rgba8);

		int offsetMax = 3;
		AddImageWithOverlay(destImage,feetAlbedo,bottomOverlay,0,offsetMax,new Color(255,0,0,255), 0.5f);
		AddImageWithOverlay(destImage,handsAlbedo,leftOverlay,1,offsetMax,new Color(0,255,0,255), 0.5f);
		AddImageWithOverlay(destImage,legsAlbedo,middleOverlay,2,offsetMax,new Color(0,0,255,255),0.5f);
		//AddImageWithOverlay(destImage,torsoAlbedo,rightOverlay,3,offsetMax,new Color(255,255,0,255),0.1f);

		Image newImage = Image.CreateFromData(newWidth,newHeight,true, Image.Format.Rgba8,destImage.GetData());
		ImageTexture newTexture = ImageTexture.CreateFromImage(newImage);
		textRect.Texture = newTexture;
	}

	public override void _Process(double delta)
	{
	}
}
