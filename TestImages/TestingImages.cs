using Godot;

public partial class TestingImages : Control
{
	[Export] TextureRect textRect;

	void AddImage(byte[] mainImageBytes, string imageToAddPath, int offset, Color color)
	{
		Image img = GD.Load<Image>(imageToAddPath);
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
		/*Image feetImage = GD.Load<Image>("res://TestModel/Textures/Feet/Albedo.png");
		Image handsImage = GD.Load<Image>("res://TestModel/Textures/Hands/Albedo.png");
		Image legsImage = GD.Load<Image>("res://TestModel/Textures/Legs/Albedo.png");
		Image torsoImage = GD.Load<Image>("res://TestModel/Textures/Torso/Albedo.png");
		Image colorImage = GD.Load<Image>("res://TestImages/colors.png");
		byte[] feetData = feetImage.GetData();
		byte[] handsData = handsImage.GetData();
		byte[] legsData = legsImage.GetData();
		byte[] torsoData = torsoImage.GetData();
		byte[] colorData = colorImage.GetData();*/

		int width = 512;
		int height = 512;

		Image destImage = Image.Create(width * 4,height,true, Image.Format.Rgba8);
		byte[] destData = destImage.GetData();
		AddImage(destData,"res://TestModel/Textures/Feet/Albedo.png",0,new Color(255,0,0,255));
		AddImage(destData,"res://TestModel/Textures/Hands/Albedo.png",1,new Color(0,255,0,255));
		AddImage(destData,"res://TestModel/Textures/Legs/Albedo.png",2,new Color(0,0,255,255));
		AddImage(destData,"res://TestModel/Textures/Torso/Albedo.png",3,new Color(255,255,0,255));

		Image newImage = Image.CreateFromData((width * 4),height,true, Image.Format.Rgba8,destData);
		ImageTexture newTexture = ImageTexture.CreateFromImage(newImage);
		textRect.Texture = newTexture;
	}

	public override void _Process(double delta)
	{
	}
}
