#if TOOLS
using Godot;

namespace AWOC
{
	[Tool]
	public partial class Plugin : EditorPlugin
	{
		Control _dock;
		const string EDITOR_UI_SCENE_PATH = "res://addons/AWOC/Scenes/AWOCEditor/awoc_editor.tscn";

		public override void _EnterTree()
		{
			_dock = GD.Load<PackedScene>(EDITOR_UI_SCENE_PATH).Instantiate<Control>();
			_dock.Name = "AWOC";
			AddControlToDock(DockSlot.LeftUr, _dock);
		}

		public override void _ExitTree()
		{
			RemoveControlFromDocks(_dock);
			_dock.Free();
		}
	}
}
#endif