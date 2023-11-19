using Godot;

namespace AWOC
{
	[Tool]
	public partial class OverlayRowRes : Resource
	{
		[Export] public float[] strengths;

		public OverlayRowRes(){}

		public OverlayRowRes(int arraySize)
		{
			strengths = new float[arraySize];
		}
	}
}