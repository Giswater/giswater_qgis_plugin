from ..parent_action import GwParentAction

from ...actions.epa.go2epa import GwGo2Epa

class GwGo2EpaButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.go2epa = GwGo2Epa(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.go2epa.go2epa()
		