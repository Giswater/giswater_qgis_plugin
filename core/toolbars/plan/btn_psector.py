from ..parent_action import GwParentAction

from ...actions.plan.plan_func import GwPlan

class GwPsectorButton(GwParentAction):
	
	def __init__(self, icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir):
		super().__init__(icon_path, text, toolbar, action_group, iface, settings, controller, plugin_dir)
		
		self.plan = GwPlan(self.iface, self.settings, self.controller, self.plugin_dir)
	
	
	def clicked_event(self):
		self.plan.master_new_psector()
		