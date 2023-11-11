using Godot;
using System;

namespace AWOC
{
	[Tool]
	public partial class MaterialPreview : BasePreviewPane
	{
		[Export] BaseMaterial3D previewMaterial;
		
		void SetPreviewTexture(Texture2D texture)
		{
			previewMaterial.AlbedoTexture = texture;
		}
	}
}