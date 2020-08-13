from ..parent_action import GwParentAction

from ...actions.utilities.toolbox import GwToolBox

class GwToolBoxButton(GwParentAction):
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.toolbox = GwToolBox(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.toolbox.open_toolbox()