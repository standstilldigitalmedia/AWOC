using Godot;

namespace AWOC
{
    [Tool]
    public partial class MaterialRes : Resource
    {
        [Export] string material_name;
        [Export] Texture2D albedo_texture;
    }
}