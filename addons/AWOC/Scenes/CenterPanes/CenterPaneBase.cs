using Godot;

namespace AWOC
{
	[Tool]
	public abstract partial class CenterPaneBase: Node
	{
        [Export] public AWOCEditor awocEditor;
		[Export] public AWOCRes awocObj;

		public abstract void InitPane(AWOCEditor awocEditor);
	}
}