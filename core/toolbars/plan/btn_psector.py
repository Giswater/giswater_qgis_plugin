from ..parent_action import GwParentAction

from ...actions.plan.psector import GwPsector

class GwPsectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.psector = GwPsector(iface, settings, controller, plugin_dir)
	
	
	def clicked_event(self):
		self.psector.new_psector()
		