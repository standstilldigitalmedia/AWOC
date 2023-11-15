using Godot;

namespace AWOC
{
	[Tool]
	public partial class MeshPreview : BasePreviewPane
	{
		[Export] SubViewport viewport;
		[Export] Camera3D camera;

		Node3D subject;

		Vector3 direction = Vector3.Zero;
		int rotate = 0;
		int moveSpeed = 5;
		int zoomSpeed = 10;
		int rotateSpeed = 3;
		Vector3 cameraPosition;

		void FreeSubject()
		{
			if(subject != null)
			{
				subject.QueueFree();
				subject = null;
			}
		}

		public void SetNewSubject(Node3D newSubject)
		{
			FreeSubject();
			subject = newSubject;
			viewport.AddChild(subject);
		}

		public override void _Ready()
		{
			cameraPosition = camera.Position;
		}
		
		public override void _Process(double delta)
		{
			if(direction != Vector3.Zero)
			{
				Vector3 newPosition = camera.Position;
				if(direction.X > 0)
				{
					newPosition.X = camera.Position.X + (moveSpeed * (float)delta);
				}
				else if(direction.X < 0)
				{
					newPosition.X = camera.Position.X - (moveSpeed * (float)delta);
				}
				else if(direction.Y > 0)
				{
					newPosition.Y = camera.Position.Y + (moveSpeed * (float)delta);
				}
				else if(direction.Y < 0)
				{
					newPosition.Y = camera.Position.Y - (moveSpeed * (float)delta);
				}
				else if(direction.Z > 0)
				{
					newPosition.Z = camera.Position.Z + (zoomSpeed * (float)delta);
				}
				else if(direction.Z < 0)
				{
					newPosition.Z = camera.Position.Z - (zoomSpeed * (float)delta);
				}
				camera.Position = newPosition;
			}
			if(subject != null)
			{
				if(rotate > 0)
				{
					subject.RotateY(rotateSpeed * (float)delta);
				}
				else if(rotate < 0)
				{
					subject.RotateY(-rotateSpeed * (float)delta);
				}
			}
		}

		void on_button_up()
		{
			direction = Vector3.Zero;
			rotate = 0;
		}

		void _on_left_button_down()
		{
			direction.X = 1;
		}

		void _on_right_button_down()
		{
			direction.X = -1;
		}

		void _on_up_button_down()
		{
			direction.Y = -1;
		}

		void _on_down_button_down()
		{
			direction.Y = 1;
		}

		void _on_zoom_in_button_down()
		{
			direction.Z = -1;
		}

		void _on_zoom_out_button_down()
		{
			direction.Z = 1;
		}

		void _on_rotate_left_button_down()
		{
			rotate = -1;
		}

		void _on_rotate_right_button_down()
		{
			rotate = 1;
		}

		void _on_center_pressed()
		{
			camera.Position = cameraPosition;
			subject.Rotation = Vector3.Zero;
		}
	}
}