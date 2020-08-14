from ..parent_action import GwParentAction

from ...actions.om.mincut import GwMincut

class GwMincutButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.mincut = GwMincut()
	
	
	def clicked_event(self):
		self.mincut.mg_mincut()
		