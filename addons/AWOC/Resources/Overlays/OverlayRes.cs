using Godot;

namespace AWOC
{
    [Tool]
    public partial class OverlayRes : Resource
    {
        [Export] string overlayName;
        [Export] Texture2D overlayTexture;
        [Export] bool useColor;
        [Export] Color overlayColor;
        [Export] float overlayColorStrength;
        [Export] bool useMetallic;
        [Export] float metallicStrength;
        [Export] bool useRoughness;
        [Export] float roughnessStrength;
        [Export] bool useHeight;
        [Export] float heightStrength;
        [Export] bool useEmission;
        [Export] Color emissionColor;
        [Export] float emissionStrength;
    }
}

