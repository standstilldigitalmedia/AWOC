@tool
class_name AWOCTabBarTab extends AWOCControlBase

var awoc_resource_controller: AWOCResourceController
var preview_control: AWOCPreviewControl
var slots_tab: AWOCSlotsTab
var meshes_tab: AWOCMeshesTab
var colors_tab: AWOCColorsTab
var materials_tab: AWOCMaterialsTab
var recipes_tab: AWOCRecipesTab
var tab_label: Label
var tab_container: TabContainer
var tab_panel_container: PanelContainer

func reset_tab():
	slots_tab.reset_tab()
	tab_container.set_current_tab(0)
	
func _on_tab_selected(index: int):
	preview_control.visible = false
	match index:
		0:
			slots_tab.reset_tab()
		1:
			meshes_tab.reset_tab()
		2:
			colors_tab.reset_tab()
		3:
			materials_tab.reset_tab()
		4:
			recipes_tab.reset_tab()

func create_controls():
	set_transparent_panel_container()
	tab_panel_container = create_simi_transparent_panel_container()
	tab_label = create_label(awoc_resource_controller.awoc_resource.awoc_name)
	tab_container = create_tab_container()
	slots_tab = AWOCSlotsTab.new(awoc_resource_controller)
	meshes_tab = AWOCMeshesTab.new(awoc_resource_controller, preview_control)
	colors_tab = AWOCColorsTab.new(awoc_resource_controller)
	materials_tab = AWOCMaterialsTab.new(awoc_resource_controller)
	recipes_tab = AWOCRecipesTab.new(awoc_resource_controller, preview_control)
	
func parent_controls():
	var inner_vbox = create_vbox(0)
	inner_vbox.add_child(tab_container)
	inner_vbox.add_child(tab_panel_container)
	var outer_vbox = create_vbox(10)
	outer_vbox.add_child(tab_label)
	outer_vbox.add_child(inner_vbox)
	add_child(outer_vbox)
	tab_container.add_child(slots_tab)
	tab_container.add_child(meshes_tab)
	tab_container.add_child(colors_tab)
	tab_container.add_child(materials_tab)
	tab_container.add_child(recipes_tab)
	tab_container.set_tab_title(0, "Slots")
	tab_container.set_tab_title(1, "Meshes")
	tab_container.set_tab_title(2, "Colors")
	tab_container.set_tab_title(3, "Materials")
	tab_container.set_tab_title(4, "Recipes")

func _init(ar_controller: AWOCResourceController, preview: AWOCPreviewControl):
	preview_control = preview
	awoc_resource_controller = ar_controller
	super()
