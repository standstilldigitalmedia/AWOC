using Godot;
using System;

namespace AWOC
{
	[Tool]
	public partial class Welcome : BaseCenterPane
	{
		[Export] FileDialog newAWOCDialog;
		[Export] FileDialog loadAWOCDialog;

		void _on_new_awoc_dialog_file_selected(string path)
		{
            awocEditor.awocObj = new AWOCRes(GetFileNameFromPath(path));
            awocEditor.awocPath = path;
			awocEditor.SaveCurrentAWOC();
			awocEditor.LoadPane(awocEditor.slotsPane);
		}

		public override void _Ready()
		{
			InitFileDialog(loadAWOCDialog);
			InitFileDialog(newAWOCDialog);
		}
	}
}
	/*

		

		public override void _Process(double delta)
		{
		}

		
	}
}


/*
func 

func _on_load_awoc_dialog_file_selected(path: String):
	var temp_awoc: Resource = load(path)
	if temp_awoc is AWOCRes:
		awoc_editor.awoc_path = path
		awoc_editor.awoc_obj = temp_awoc
		temp_awoc.load_source_avatar()
		awoc_editor.load_pane(awoc_editor.slots_pane)

func _on_new_awoc_button_pressed():
	new_awoc_dialog.visible = true

func _on_load_awoc_button_pressed():
	load_awoc_dialog.visible = true*/

