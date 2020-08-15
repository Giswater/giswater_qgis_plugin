from ..parent_action import GwParentAction

from ...actions.toc.manage_layers import GwManageLayers

class GwAddChildLayerButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.manage_layers = GwManageLayers()
		self.manage_layers.config_layers()
	
	
	def clicked_event(self):
		self.manage_layers.create_add_layer_menu()
		